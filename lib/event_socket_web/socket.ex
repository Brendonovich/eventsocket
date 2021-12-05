defmodule EventSocketWeb.Socket do
  @behaviour Phoenix.Socket.Transport

  alias EventSocketWeb.Socket.TerminationRegistry
  alias EventSocket.PubSub.Events

  @impl true
  def child_spec(_opts) do
    %{id: Task, start: {Task, :start_link, [fn -> :ok end]}, restart: :transient}
  end

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

    def new(type, payload \\ %{}, metadata \\ %{}) do
      %Reply{
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
    end

    def encode(reply) do
      {:text, Jason.encode_to_iodata!(reply)}
    end
  end

  @impl true
  def connect(%{params: %{"api_key" => api_key}}),
    do: connect_impl(EventSocket.Users.by_api_key(api_key))

  def connect_impl(nil), do: {:error, "Invalid API key"}

  def connect_impl(user) do
    case EventSocket.Sockets.register(user.id) do
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
  @spec init(State.t()) :: {:ok, State.t()}
  def init(state) do
    TerminationRegistry.register()
    EventSocket.PubSub.subscribe_user_events(state.user_id)

    {:ok, state |> queue_ping}
  end

  def queue_ping(%State{} = state) do
    if !is_nil(state.ping_timer), do: Process.cancel_timer(state.ping_timer)

    %{state | ping_timer: Process.send_after(self(), :ping, 15000)}
  end

  @impl true
  def handle_info(data, state),
    do: {
      :push,
      data |> handle_event |> Reply.encode(),
      state |> queue_ping
    }

  def handle_event(%Events.User.EventsubNotification{} = data) do
    Reply.new(
      "notification",
      %{
        subscription: %{
          condition: data.condition,
          type: data.type
        },
        event: data.event
      },
      %{
        subscription_type: data.type
      }
    )
  end

  def handle_event(:notify_shutdown), do: Reply.new("websocket_reconnect")
  def handle_event(:ping), do: Reply.new("websocket_keepalive")

  def notify_shutdown(pid) do
    send(pid, :notify_shutdown)
  end

  @impl true
  def handle_in(_in, state) do
    {:stop, :exit, state}
  end

  @impl true
  def terminate(_reason, state) do
    EventSocket.Sockets.delete!(state.id)
    :ok
  end
end
