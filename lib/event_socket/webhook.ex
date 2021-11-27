defmodule EventSocket.Webhook do
  @webhook_pending "webhook_callback_verification_pending"
  @authorization_revoked "authorization_revoked"

  def signature_valid?(headers, raw_data) do
    signature_input =
      "#{headers.id}" <>
        "#{headers.timestamp}" <>
        "#{raw_data}"

    encoded =
      "#{:crypto.mac(:hmac, :sha256, EventSocket.Secrets.secret_key_base(), signature_input) |> Base.encode16()}"
      |> String.downcase()

    "sha256=" <> signature = headers.signature |> String.downcase()

    signature == encoded
  end

  def handle_event(%{"subscription" => %{"status" => @webhook_pending}, "challenge" => challenge}),
    do: {:ok, challenge}

  def handle_event(%{"subscription" => %{"status" => @authorization_revoked}}),
    do: {:ok, "Authorization revoked"}

  def handle_event(%{"subscription" => subscription, "event" => event}) do
    case EventSocket.Conditions.deconstruct(subscription["condition"]) do
      {:ok, user_id, condition} ->
        EventSocket.PubSub.broadcast(
          "user_events:#{user_id}",
          {:eventsub_event,
           %{
             type: subscription["type"],
             event: event,
             condition: condition
           }}
        )

      {:error, _} ->
        # TODO: Handle error
        nil
    end

    {:ok, ""}
  end
end
