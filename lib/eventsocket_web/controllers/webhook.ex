# TODO: Move this to EventSocket instead of EventSocketWeb
defmodule EventSocketWeb.WebhookController do
  use EventSocketWeb, :controller

  alias EventSocket.Webhook
  alias EventSocket.Webhook.Event

  def handle_event(%Plug.Conn{} = conn, _opts) do
    if !Webhook.signature_valid?(
         %{
           id: get_req_header(conn, "twitch-eventsub-message-id") |> Enum.at(0),
           timestamp: get_req_header(conn, "twitch-eventsub-message-timestamp") |> Enum.at(0),
           signature: get_req_header(conn, "twitch-eventsub-message-signature") |> Enum.at(0)
         },
         conn.assigns.raw_body
       ) do
      conn |> send_resp(401, "LMAOOO") |> halt
    else
      case Webhook.process_event(Event.new(Enum.into(conn.req_headers, %{}), conn.params)) do
        {:ok, data} ->
          conn |> put_resp_content_type("text/plain") |> send_resp(200, data) |> halt

          # {:error, error} ->
          #   send_resp(conn, 500, error)
      end
    end
  end
end
