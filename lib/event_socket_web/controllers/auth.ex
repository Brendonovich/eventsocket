# Auth
#
# There are two modes of authentication: Session cookie or API key
# Session cookies are for the web frontend
# API keys are for user code that connects to the websocket

defmodule EventSocketWeb.AuthController do
  use EventSocketWeb, :controller

  alias EventSocket.Users

  def generate_api_key(conn, body) do
    api_key = Users.generate_api_key(conn.assigns.user_id)

    conn |> send_resp(200, api_key)
  end
end
