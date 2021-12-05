defmodule EventSocket.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias EventSocket.{TwitchAPI, UserServer}

  def start(_type, _args) do
    children = [
      # Autoclustering
      {Cluster.Supervisor,
       [Application.get_env(:libcluster, :topologies), [name: EventSocket.ClusterSupervisor]]},

      # Database
      EventSocket.Repo,

      # PubSub
      {Phoenix.PubSub, name: EventSocket.PubSub},

      # UserServer stack
      # Children are shut down in reverse order of creation
      # Putting UserServer stuff up top allows it to outlive sockets,
      # so that by the time the UserServer is shut down, all sockets
      # that need to unregister themselves have been closed
      UserServer.Registry,
      UserServer.Supervisor,
      UserServer.NodeListener,

      # Exit signal flows from TerminationRegistry -> Drainer -> Endpoint
      # TerminationRegistry notifies all sockets of impending shutdown & updates state accordingly
      # Drainer waits a grace period for sockets to be closed by clients
      # Endpoint forces all sockets to close

      # HTTP endpoint
      EventSocketWeb.Endpoint,

      # Twitch credential manager
      TwitchAPI.Credentials,

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
  def config_change(changed, _new, removed) do
    EventSocketWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
