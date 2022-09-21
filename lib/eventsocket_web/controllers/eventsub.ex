defmodule EventSocketWeb.EventSubController do
  use EventSocketWeb, :controller

  alias EventSocket.Subscription

  @spec create_subscription(Plug.Conn.t(), map) :: Plug.Conn.t()
  def create_subscription(conn, %{"type" => type}) do
    case Subscription.create_subscription(
           type,
           conn.assigns.user_id
         ) do
      {:ok, subscription} -> resp(conn, 200, Jason.encode_to_iodata!(subscription))
      {:error, error} -> resp(conn, 500, Jason.encode_to_iodata!(error))
    end
  end

  def get_subscriptions(conn, _data) do
    subscriptions = Subscription.by_user(conn.assigns.user_id)
    resp(conn, 200, Jason.encode_to_iodata!(subscriptions))
  end

  def delete_subscription(%Plug.Conn{} = conn, _data) do
    case conn.query_params["id"] do
      nil ->
        resp(conn, 400, "Missing id")

      id ->
        Subscription.delete_subscription!(id)

        resp(conn, 200, "")
    end
  end
end
