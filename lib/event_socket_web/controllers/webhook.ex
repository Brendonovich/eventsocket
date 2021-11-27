# TODO: Move this to EventSocket instead of EventSocketWeb
defmodule EventSocketWeb.WebhookController do
  use EventSocketWeb, :controller

  alias EventSocket.Webhook

  def handle_event(conn, _opts) do
    if !Webhook.signature_valid?(
         %{
           id: get_req_header(conn, "twitch-eventsub-message-id") |> Enum.at(0),
           timestamp: get_req_header(conn, "twitch-eventsub-message-timestamp") |> Enum.at(0),
           signature: get_req_header(conn, "twitch-eventsub-message-signature") |> Enum.at(0)
         },
         conn.assigns.raw_body
       ) do
      send_resp(conn, 401, "")
    end

    case Webhook.handle_event(conn.params) do
      {:ok, data} -> send_resp(conn, 200, data)
      # {:error, error} -> send_resp(conn, 500, error)
    end
  end
end
