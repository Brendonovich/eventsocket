defmodule EventSocket.Env do
  def twitch_client_id, do: get_env(:twitch)[:client_id]
  def twitch_client_secret, do: get_env(:twitch)[:client_secret]
  def secret_key_base, do: get_env(EventSocketWeb.Endpoint)[:secret_key_base]
  def self_origin, do: get_env(:self_origin)
  def web_origin, do: get_env(:web_origin)

  defp get_env(name), do: Application.get_env(:eventsocket, name)
end
