use Mix.Config

database_url =
  System.fetch_env("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

config :event_socket, EventSocket.Repo,
  url: database_url,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

secret_key_base =
  System.fetch_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :event_socket, EventSocketWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000"),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: secret_key_base

config :event_socket, :twitch,
  client_id:
    System.fetch_env("TWITCH_CLIENT_ID") ||
      raise("environment variable TWITCH_CLIENT_ID is missing"),
  client_secret:
    System.fetch_env("TWITCH_CLIENT_SECRET") ||
      raise("environment variable TWITCH_CLIENT_SECRET is missing"),
  redirect_uri:
    System.fetch_env("TWITCH_REDIRECT_URI") ||
      raise("environment variable TWITCH_REDIRECT_URI is missing")

origin_url =
  System.fetch_env("ORIGIN_URL") ||
    raise("environment variable ORIGIN_URL is missing")

config :event_socket,
  webhook_callback: origin_url <> "/webhook"

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
config :event_socket, EventSocketWeb.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.
