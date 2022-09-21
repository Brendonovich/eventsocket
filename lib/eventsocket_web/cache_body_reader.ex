defmodule EventSocketWeb.CacheBodyReader do
  alias Plug.Conn

  def read_body(conn, opts) do
    {:ok, body, conn} = Conn.read_body(conn, opts)
    conn = Conn.assign(conn, :raw_body, body)
    {:ok, body, conn}
  end
end
