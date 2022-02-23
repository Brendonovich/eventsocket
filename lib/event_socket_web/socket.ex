defmodule EventSocketWeb.Socket do
  @behaviour Phoenix.Socket.Transport

  alias EventSocketWeb.Socket.TerminationRegistry
  alias EventSocket.{PubSub, UserServer, Users}
  alias EventSocket.PubSub.Events.User.EventsubNotification

  @impl true
  def child_spec(_opts),
    do: %{id: Task, start: {Task, :start_link, [fn -> :ok end]}, restart: :transient}

  defmodule State do
    @type t :: %__MODULE__{
            id: Ecto.UUID.t(),
            user_id: integer,
            ping_timer: any
          }

    defstruct id: "", ping_timer: nil, user_id: 0
  end

  defmodule Reply do
    @derive Jason.Encoder
    defstruct metadata: %{}, payload: %{}

    def new(type, payload \\ %{}, metadata \\ %{}),
      do: %Reply{
        metadata:
          Map.merge(
            metadata,
            %{
              message_id: Map.get(metadata, :message_id, Ecto.UUID.generate()),
              message_type: type,
              message_timestamp: DateTime.utc_now() |> DateTime.to_iso8601()
            }
          ),
        payload: payload
      }

    def encode(reply), do: {:text, Jason.encode_to_iodata!(reply)}
  end

  @impl true
  def connect(%{params: %{"api_key" => api_key}}),
    do: api_key |> Users.by_api_key() |> connect_impl

  def connect_impl(nil), do: {:error, "Invalid API key"}

  def connect_impl(user) do
    case UserServer.register_socket(user.id) do
      {:ok, socket} ->
        {:ok,
         %State{
           id: socket.id,
           user_id: user.id
         }}

      {:error, _} ->
        :error
    end
  end

  @impl true
  def init(%State{} = state) do
    TerminationRegistry.register()
    PubSub.subscribe_user_events(state.user_id)

    {:ok, state |> queue_ping}
  end

  def queue_ping(%State{} = state) do
    if !is_nil(state.ping_timer), do: Process.cancel_timer(state.ping_timer)

    %{state | ping_timer: Process.send_after(self(), :ping, 15000)}
  end

  @impl true
  def handle_info(:notify_shutdown, state) do
    UserServer.unregister_socket(state.user_id, state.id)
    Process.cancel_timer(state.ping_timer)

    {:push, Reply.new("websocket_reconnect") |> Reply.encode(), state}
  end

  @impl true
  def handle_info(data, state),
    do: {
      :push,
      data |> handle_event |> Reply.encode(),
      state |> queue_ping
    }

  def handle_event(%EventsubNotification{} = notification) do
    Reply.new(
      "notification",
      %{
        subscription: %{
          type: notification.type
        },
        event: notification.event
      },
      %{
        subscription_type: notification.type
      }
    )
  end

  def handle_event(:ping), do: Reply.new("websocket_keepalive")

  def notify_shutdown(pid), do: send(pid, :notify_shutdown)

  @impl true
  def handle_in(_in, state), do: {:stop, :exit, state}

  @impl true
  def terminate(_reason, state) do
    # Registry may not have been initialized yet, so igno
    try do
      TerminationRegistry.unregister()
    catch
      :exit, {:noproc, _} -> :ok
    end

    UserServer.unregister_socket(state.user_id, state.id)

    :ok
  end
end
