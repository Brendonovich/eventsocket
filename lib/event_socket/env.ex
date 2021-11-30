defmodule EventSocket.Env do
  alias EventSocket.Utilities

  def twitch_client_id, do: Utilities.get_env(:twitch)[:client_id]
  def twitch_client_secret, do: Utilities.get_env(:twitch)[:client_secret]
  def secret_key_base, do: Utilities.get_env(EventSocketWeb.Endpoint)[:secret_key_base]
  def self_origin, do: Utilities.get_env(:self_origin)
  def web_origin, do: Utilities.get_env(:web_origin)
end
