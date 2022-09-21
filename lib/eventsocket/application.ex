defmodule EventSocket.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias EventSocket.{Twitch, UserServer}

  @impl true
  def start(_type, _args) do
    topologies = Application.get_env(:libcluster, :topologies) || []

    children = [
      # Autoclustering
      {Cluster.Supervisor, [topologies, [name: EventSocket.ClusterSupervisor]]},

      # Start the Ecto repository
      EventSocket.Repo,

      # Start the Telemetry supervisor
      # EventSocketWeb.Telemetry,

      # Start the PubSub system
      {Phoenix.PubSub, name: EventSocket.PubSub},

      # UserServer stack
      # Children are shut down in reverse order of creation
      # Putting UserServer stuff up top allows it to outlive sockets,
      # so that by the time the UserServer is shut down, all sockets
      # that need to unregister themselves have been closed
      UserServer.Registry,
      UserServer.Supervisor,
      UserServer.NodeListener,

      # Twitch auth manager
      Twitch.Auth,

      # Start the Endpoint (http/https)
      EventSocketWeb.Endpoint,

      # Socket drainer
      {Plug.Cowboy.Drainer, refs: :all, shutdown: 10000},

      # Socket termination handler
      EventSocketWeb.Socket.TerminationRegistry
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: EventSocket.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    EventSocketWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
