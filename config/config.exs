# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :eventsocket,
  ecto_repos: [EventSocket.Repo]

# Configures the endpoint
config :eventsocket, EventSocketWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "qq+EwdFJ9/KYjL3Rps72JOkzbFP2hhJDM2upwf/lh41OVVn2MtfHBt0UFFNn8AgA",
  render_errors: [view: EventSocketWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: EventSocket.PubSub,
  live_view: [signing_salt: "FrxIfkQ6SsCc_RCB"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :libcluster,
  topologies: [
    gossip: [
      strategy: EventSocket.Cluster.Strategy.Gossip,
      config: [
        secret: "gossip_secret"
      ]
    ]
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
