defmodule EventSocketWeb.Plugs.Auth do
  @behaviour Plug

  import Plug.Conn

  alias EventSocket.{User, Session}

  def init(opts), do: opts

  @spec call(Plug.Conn.t(), map) :: Plug.Conn.t()
  def call(conn, _params) do
    conn = conn |> fetch_session()

    cond do
      (session_id = conn.cookies["session"]) != nil ->
        case Session.get(session_id) do
          nil ->
            conn |> send_resp(403, "Invalid session") |> halt

          session ->
            assign(conn, :user_id, session.user_id)
        end

      (header_api_key = get_req_header(conn, "authorization") |> Enum.at(0)) != nil ->
        case User.by_api_key(header_api_key) do
          nil ->
            conn |> send_resp(403, "Invalid API key") |> halt

          user ->
            assign(conn, :user_id, user.id)
        end

      true ->
        conn |> send_resp(401, "No authentication provided") |> halt
    end
  end
end
