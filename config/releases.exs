import Config

config :eventsocket, EventSocket.Repo,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

config :eventsocket, EventSocketWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000"),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: System.get_env("SECRET_KEY_BASE")

config :eventsocket, :twitch,
  client_id: System.fetch_env!("TWITCH_CLIENT_ID"),
  client_secret: System.fetch_env!("TWITCH_CLIENT_SECRET"),
  redirect_uri: System.fetch_env!("TWITCH_REDIRECT_URI")

origin_url = System.fetch_env!("ORIGIN_URL")

config :eventsocket,
  webhook_callback: origin_url <> "/webhook"

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.
