defmodule EventSocketWeb.Plugs.AdminAuth do
  @behaviour Plug

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _params) do
    if get_req_header(conn, "authorization")[0] != EventSocket.Env.secret_key_base() &&
         conn.cookies["admin_auth"] !=
           EventSocket.Env.secret_key_base() do
      conn |> send_resp(401, "Invalid Authorization") |> halt
    else
      conn
    end
  end
end
