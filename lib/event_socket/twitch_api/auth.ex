defmodule EventSocket.TwitchAPI.Auth do
  alias EventSocket.{Env, Constants, TwitchAPI}

  def request_app_access_token(scopes \\ "") do
    response =
      HTTPoison.post!(
        "https://id.twitch.tv/oauth2/token",
        "",
        [],
        params: %{
          client_id: Env.twitch_client_id(),
          client_secret: Env.twitch_client_secret(),
          grant_type: "client_credentials",
          scopes: scopes
        }
      )

    case response do
      %HTTPoison.Response{status_code: 200, body: body} ->
        {:ok, Jason.decode!(body)["access_token"]}

      _ ->
        :error
    end
  end

  def get_jwt_public_key do
    response = HTTPoison.get!("https://id.twitch.tv/oauth2/keys")

    case response do
      %HTTPoison.Response{status_code: 200, body: body} ->
        {:ok, Jason.decode!(body)["keys"] |> Enum.at(0)}

      _ ->
        :error
    end
  end

  def login_redirect_url do
    "https://id.twitch.tv/oauth2/authorize" <>
      "?client_id=#{Env.twitch_client_id()}" <>
      "&redirect_uri=#{Env.twitch_redirect_uri()}" <>
      "&response_type=code" <> "&scope=#{Enum.join(Constants.twitch_auth_scopes(), " ")}"
  end

  def get_oauth_token(code) do
    response =
      HTTPoison.post!(
        "https://id.twitch.tv/oauth2/token",
        "",
        [],
        params: %{
          client_id: Env.twitch_client_id(),
          client_secret: Env.twitch_client_secret(),
          grant_type: "authorization_code",
          redirect_uri: Env.twitch_redirect_uri(),
          code: code
        }
      )

    case response do
      %HTTPoison.Response{status_code: 200, body: body} ->
        {:ok, Jason.decode!(body)}

      _ ->
        :error
    end
  end

  def authorize_oauth_token(code) do
    {:ok, token} = get_oauth_token(code)

    {true, %{:fields => id_token}, _} =
      JOSE.JWT.verify(TwitchAPI.Credentials.get_jwt_public_key(), token["id_token"])

    id_token
  end
end
