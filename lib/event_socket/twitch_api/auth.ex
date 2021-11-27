defmodule EventSocket.TwitchAPI.Auth do
  alias EventSocket.Secrets

  def request_app_access_token(scopes \\ "") do
    response =
      HTTPoison.post!(
        "https://id.twitch.tv/oauth2/token",
        "",
        [],
        params: %{
          client_id: Secrets.twitch_client_id(),
          client_secret: Secrets.twitch_client_secret(),
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
end
