defmodule EventSocket.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias EventSocket.TwitchAPI

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      EventSocket.Repo,
      # Start the Telemetry supervisor
      # EventSocketWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: EventSocket.PubSub},
      # Start the Endpoint (http/https)
      EventSocketWeb.Endpoint,
      TwitchAPI.Credentials,
      {Plug.Cowboy.Drainer, refs: :all, shutdown: 10000},
      EventSocketWeb.Socket.TerminationRegistry,
      {Cluster.Supervisor,
       [Application.get_env(:libcluster, :topologies), [name: EventSocket.ClusterSupervisor]]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: EventSocket.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    EventSocketWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
