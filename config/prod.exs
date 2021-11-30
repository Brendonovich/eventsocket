import Config

# Do not print debug messages in production
config :logger, level: :debug

config :eventsocket, EventSocketWeb.Endpoint, server: true
