defmodule EventSocket.Subscriptions do
  alias EventSocket.{
    TwitchAPI.Helix,
    PubSub,
    Conditions,
    Utilities,
    Repo.Subscriptions,
    Repo.Schemas,
    Repo.Mutations
  }

  @spec create_subscription(String.t(), integer, map) ::
          {:ok, Schemas.Subscription.t()} | {:error, atom}
  def create_subscription(type, user_id, condition) do
    {:ok, twitch_condition} = Conditions.construct(type, "#{user_id}", condition)

    subscription_data = %{
      type: type,
      condition: condition,
      user_id: user_id
    }

    subscription_hash = EventSocket.Repo.Schemas.Subscription.hash(subscription_data)

    # Create blank subscription in database
    case Subscriptions.create(subscription_data) do
      {:ok, _} ->
        try do
          # Create EventSub subscription
          with {:ok, response} <- Helix.EventSub.create_subscription(type, twitch_condition),
               %{"data" => [data]} <- Utilities.decode_body(response),
               # EventSub subscription created, update the database entry
               # with the subscription's ID and status
               {:ok, subscription} <-
                 Subscriptions.update(
                   type,
                   user_id,
                   condition,
                   %{
                     id: data["id"],
                     status: data["status"]
                   }
                 ) do
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
            Subscriptions.delete_by_hash(subscription_hash)
            IO.inspect(error)
            {:error, :create_subscription_failed}
        end

      {:error, _} ->
        {:error, :subscription_already_exists}
    end
  end

  def delete_subscription(id) do
    Helix.EventSub.delete_subscription(id)

    Subscriptions.delete_by_id(id)

    {:ok}
  end

  @spec get_for_user(integer) :: [EventSocket.Repo.Schemas.Subscription.t()]
  def get_for_user(user_id) do
    Subscriptions.all(user_id)
  end

  defdelegate set_status(id, status), to: Mutations.Subscriptions
end
