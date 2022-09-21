defmodule EventSocket.Twitch.Helix do
  alias EventSocket.Twitch
  alias EventSocket.Env

  def post!(path, body \\ %{}, params \\ %{}) do
    HTTPoison.post!(
      url(path),
      Jason.encode!(body),
      headers(),
      params: params
    )
  end

  def get!(path, params \\ %{}) do
    HTTPoison.get!(
      url(path),
      headers(),
      params: params
    )
  end

  def delete!(path, params \\ %{}) do
    HTTPoison.delete!(
      url(path),
      headers(),
      params: params
    )
  end

  defp url(path), do: "https://api.twitch.tv/helix/#{path}"

  defp headers,
    do: %{
      "Client-ID" => Env.twitch_client_id(),
      "Authorization" => "Bearer #{Twitch.Auth.app_access_token()}",
      "Content-Type" => "application/json"
    }

  def get_user!(id) do
    get!("users", %{"id" => id})
    |> Map.get("data")
    |> Enum.at(0)
  end
end
