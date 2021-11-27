defmodule EventSocketWeb.Plugs.Auth do
  @behaviour Plug

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _params) do
    conn = conn |> fetch_session()

    cond do
      (session_user_id = get_session(conn, "user_id")) != nil ->
        nil

      ([header_api_key] = get_req_header(conn, "authorization")) != nil ->
        user = EventSocket.Users.by_api_key(header_api_key)

        if user != nil do
          assign(conn, :user_id, user.id)
        else
          conn |> send_resp(403, "Invalid API key provided") |> halt
        end

      true ->
        conn |> send_resp(401, "No authentication provided") |> halt
    end
  end
end
