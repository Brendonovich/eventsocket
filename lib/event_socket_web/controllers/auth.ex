# Auth
#
# There are two modes of authentication: Session cookie or API key
# Session cookies are for the web frontend
# API keys are for user code that connects to the websocket

defmodule EventSocketWeb.AuthController do
  use EventSocketWeb, :controller

  alias EventSocket.{Users, TwitchAPI, Sessions}

  @session_cookie_options [
    same_site: "Lax",
    max_age: 60 * 60 * 24 * 14
  ]

  def generate_api_key(conn, _body) do
    api_key = Users.generate_api_key(conn.assigns.user_id)

    conn |> send_resp(200, api_key)
  end

  def get_redirect_uri(conn, _body) do
    conn |> send_resp(200, TwitchAPI.Auth.login_redirect_url())
  end

  def oauth_authorize(%Plug.Conn{} = conn, _body) do
    id_token = TwitchAPI.Auth.authorize_oauth_token(conn.query_params["code"])

    user =
      Users.get_or_create_user(%{
        id: id_token["sub"] |> Integer.parse() |> elem(0),
        display_name: id_token["preferred_username"]
      })

    {:ok, session} = Sessions.create(user.id)

    conn
    |> put_resp_cookie("session", session, @session_cookie_options)
    |> send_resp(
      200,
      Jason.encode_to_iodata!(%{
        id: user.id,
        display_name: user.display_name
      })
    )
  end

  def me(%Plug.Conn{} = conn, _body) do
    user = Users.by_id(conn.assigns.user_id)

    conn
    |> send_resp(
      200,
      Jason.encode_to_iodata!(%{
        id: user.id,
        display_name: user.display_name
      })
    )
  end

  def logout(%Plug.Conn{} = conn, _body) do
    session = conn.cookies["session"]

    if !is_nil(session) do
      Sessions.delete(session)

      conn
      |> delete_resp_cookie("session", @session_cookie_options)
      |> send_resp(200, "")
    end

    conn |> send_resp(400, "No session cookie present")
  end
end
