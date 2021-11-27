defmodule EventSocket.Secrets do
  alias EventSocket.Utilities

  def twitch_client_id, do: Utilities.get_env(:twitch_credentials)[:client_id]
  def twitch_client_secret, do: Utilities.get_env(:twitch_credentials)[:client_secret]
  def webhook_callback, do: Utilities.get_env(:webhook_callback)
  def secret_key_base, do: Utilities.get_env(EventSocketWeb.Endpoint)[:secret_key_base]
end
