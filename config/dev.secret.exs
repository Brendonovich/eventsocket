use Mix.Config

config :event_socket, :twitch_credentials,
  client_id: "",
  client_secret: ""

config :event_socket,
  webhook_callback: "https://example.com/webhook"
