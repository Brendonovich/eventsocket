import Config

# Do not print debug messages in production
config :logger, level: :info

config :eventsocket, EventSocketWeb.Endpoint, server: true

config :cors_plug,
  origin: fn -> [System.fetch_env!("WEB_ORIGIN")] end
