defmodule EventSocket.Subscriptions do
  alias EventSocket.{
    TwitchAPI.Helix,
    PubSub,
    Utilities,
    Repo.Subscriptions,
    Repo.Schemas,
    Repo.Mutations,
    Events
  }

  @spec create_subscription(String.t(), integer) ::
          {:ok, Schemas.Subscription.t()} | {:error, atom}
  def create_subscription(type, user_id) do
    case Events.to_twitch(type, user_id) do
      nil ->
        {:error, :unknown_subscription_type}

      {twitch_type, twitch_condition} ->
        # Create blank subscription in database
        case Subscriptions.create(type, user_id) do
          {:ok, _} ->
            try do
              # Create EventSub subscription
              with {:ok, response} <-
                     Helix.EventSub.create_subscription(twitch_type, twitch_condition),
                   %{"data" => [data]} <- Utilities.decode_body(response),
                   # EventSub subscription created, update the database entry
                   # with the subscription's ID and status
                   {:ok, subscription} <-
                     Subscriptions.update(type, user_id, %{
                       id: data["id"],
                       status: data["status"]
                     }) do
                PubSub.broadcast!(
                  "eventsub_subscriptions",
                  {:new_eventsub_subscription, subscription}
                )

                {:ok, subscription}
              else
                {_, error} ->
                  raise error
              end
            rescue
              error ->
                Subscriptions.delete(type, user_id)
                IO.inspect(error)
                {:error, :create_subscription_failed}
            end

          {:error, _} ->
            {:error, :subscription_already_exists}
        end
    end
  end

  def delete_subscription(id) do
    Helix.EventSub.delete_subscription(id)

    Subscriptions.delete_by_id(id)

    {:ok}
  end

  def get_for_user(user_id) do
    Subscriptions.all(user_id)
  end

  defdelegate set_status(id, status), to: Mutations.Subscriptions
end
