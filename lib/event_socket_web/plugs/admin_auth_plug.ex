defmodule EventSocketWeb.Plugs.AdminAuth do
  @behaviour Plug

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _params) do
    if get_req_header(conn, "authorization") |> Enum.at(0) !=
         EventSocket.Secrets.secret_key_base() do
      conn |> send_resp(401, "Invalid Authorization") |> halt
    else
      conn
    end
  end
end
