import Config

# Do not print debug messages in production
config :logger, level: :info

config :eventsocket, EventSocketWeb.Endpoint, server: true
