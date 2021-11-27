defmodule EventSocket.TwitchAPI.Helix do
  alias EventSocket.TwitchAPI.{Credentials}
  alias EventSocket.Secrets

  def post(path, body \\ %{}, params \\ %{}) do
    HTTPoison.post(
      "https://api.twitch.tv/helix/#{path}",
      Jason.encode!(body),
      %{
        "Client-ID" => Secrets.twitch_client_id(),
        "Authorization" => "Bearer #{Credentials.get_app_access_token()}",
        "Content-Type" => "application/json"
      },
      params: params
    )
  end

  def get(path, params \\ %{}) do
    HTTPoison.get(
      "https://api.twitch.tv/helix/#{path}",
      %{
        "Client-ID" => Secrets.twitch_client_id(),
        "Authorization" => "Bearer #{Credentials.get_app_access_token()}",
        "Content-Type" => "application/json"
      },
      params: params
    )
  end

  def delete(path, params \\ %{}) do
    HTTPoison.delete(
      "https://api.twitch.tv/helix/#{path}",
      %{
        "Client-ID" => Secrets.twitch_client_id(),
        "Authorization" => "Bearer #{Credentials.get_app_access_token()}",
        "Content-Type" => "application/json"
      },
      params: params
    )
  end

  def get_user(id) do
    get("users", %{"id" => id})
    |> Map.get("data")
    |> Enum.at(0)
  end
end
