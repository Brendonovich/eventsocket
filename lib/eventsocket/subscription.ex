defmodule EventSocket.Subscription do
  alias EventSocket.{
    Twitch.Helix,
    PubSub,
    Utils,
    Event,
    Repo.Access,
    Repo.Mutation
  }

  @spec create_subscription(String.t(), integer) ::
          {:ok, Schema.Subscription.t()} | {:error, atom}
  def create_subscription(type, user_id) do
    case Event.to_twitch(type, user_id) do
      nil ->
        {:error, :unknown_subscription_type}

      {twitch_type, twitch_condition} ->
        # Create blank subscription in database
        case Mutation.Subscription.create(type, user_id) do
          {:ok, _} ->
            try do
              # Create EventSub subscription
              subscription_data =
                Helix.EventSub.create_subscription!(twitch_type, twitch_condition)
                |> Utils.decode_body()
                |> Map.get("data")
                |> Enum.at(0)

              # EventSub subscription created, update the database entry
              # with the subscription's ID and status
              case Mutation.Subscription.update(type, user_id, subscription_data) do
                {:ok, subscription} ->
                  PubSub.broadcast!(
                    "eventsub_subscriptions",
                    {:new_eventsub_subscription, subscription}
                  )

                  {:ok, subscription}

                {_, error} ->
                  raise error
              end
            rescue
              _ ->
                Mutation.Subscription.delete(type, user_id)
                {:error, :create_subscription_failed}
            end

          {:error, _} ->
            {:error, :subscription_already_exists}
        end
    end
  end

  def delete_subscription!(id) do
    Helix.EventSub.delete_subscription!(id)

    Mutation.Subscription.delete_by_id(id)
  end

  defdelegate by_user(user_id), to: Access.Subscription
  defdelegate set_status(id, status), to: Mutation.Subscription
end
