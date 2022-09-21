defmodule EventSocket.Env do
  def twitch_client_id, do: get_env(:twitch)[:client_id]
  def twitch_client_secret, do: get_env(:twitch)[:client_secret]
  def secret_key_base, do: get_env(EventSocketWeb.Endpoint)[:secret_key_base]
  def callback_origin, do: get_env(:callback_origin)

  defp get_env(name), do: Application.get_env(:eventsocket, name)
end
