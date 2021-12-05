defmodule EventSocket.Webhook do
  alias EventSocket.{Env, Subscriptions, Webhook.Event, PubSub, PubSub.Events}

  def signature_valid?(headers, raw_data) do
    signature_input =
      "#{headers.id}" <>
        "#{headers.timestamp}" <>
        "#{raw_data}"

    encoded =
      "#{:crypto.mac(:hmac, :sha256, Env.secret_key_base(), signature_input) |> Base.encode16()}"
      |> String.downcase()

    "sha256=" <> signature = headers.signature |> String.downcase()

    signature == encoded
  end

  def process_event(event = %Event{}), do: handle_event(event.headers.type, event)

  defp handle_event(:webhook_callback_verification, %Event{} = event) do
    Subscriptions.set_status(event.body["subscription"]["id"], "enabled")
    {:ok, event.body["challenge"]}
  end

  defp handle_event(:notification, %Event{} = event) do
    case EventSocket.Conditions.deconstruct(event.body["subscription"]["condition"]) do
      {:ok, user_id, condition} ->
        PubSub.broadcast_user_event!(
          user_id,
          %Events.User.EventsubNotification{
            type: event.body["subscription"]["type"],
            event: event.body["event"],
            condition: condition,
            id: event.headers.id
          }
        )

      {:error, _} ->
        IO.inspect("Failed to deconstruct condition", event.body["subscription"]["condition"])
        # TODO: Handle error
        nil
    end

    {:ok, ""}
  end

  defp handle_event(:revocation, _event),
    do: {:ok, "Authorization revoked"}
end
