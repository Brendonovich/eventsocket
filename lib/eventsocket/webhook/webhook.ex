defmodule EventSocket.Webhook do
  alias EventSocket.{Env, Subscription, Webhook, PubSub, Event}

  def signature_valid?(headers, raw_data) do
    signature_input = "#{headers.id}#{headers.timestamp}#{raw_data}"

    hmac =
      "sha256=" <>
        (:crypto.mac(:hmac, :sha256, Env.secret_key_base(), signature_input)
         |> Base.encode16(case: :lower))

    Plug.Crypto.secure_compare(hmac, headers.signature)
  end

  def process_event(event = %Webhook.Event{}), do: handle_event(event.headers.type, event)

  defp handle_event(:webhook_callback_verification, %Webhook.Event{} = event) do
    Subscription.set_status(event.body["subscription"]["id"], "enabled")
    {:ok, event.body["challenge"]}
  end

  defp handle_event(:notification, %Webhook.Event{} = event) do
    case Event.from_twitch(
           event.headers.subscription_type,
           event.body["subscription"]["condition"]
         ) do
      {type, user_id} ->
        pubsub_event = %PubSub.Event.EventsubNotification{
          type: type,
          event: event.body["event"],
          id: event.headers.id
        }

        PubSub.broadcast_user_event!(
          user_id,
          pubsub_event
        )

      # EventSocket.Events.create_from_pubsub(user_id, pubsub_event)

      nil ->
        IO.inspect("Failed to deconstruct condition", event.body["subscription"]["condition"])
        # TODO: Handle error
        nil
    end

    {:ok, ""}
  end

  defp handle_event(:revocation, _event),
    do: {:ok, "Authorization revoked"}
end
