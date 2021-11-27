defmodule EventSocketWeb.EventSubController do
  use EventSocketWeb, :controller

  alias EventSocket.Subscriptions

  def create_subscription(conn, %{"type" => type} = data) do
    case Subscriptions.create_subscription(
           type,
           conn.assigns.user_id,
           data["condition"] || %{}
         ) do
      {:ok, subscription} -> resp(conn, 200, Jason.encode_to_iodata!(subscription))
      {:error, error} -> resp(conn, 500, Jason.encode_to_iodata!(error))
    end
  end
end
