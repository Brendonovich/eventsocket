defmodule EventSocketWeb.Socket do
  @behaviour Phoenix.Socket.Transport

  alias EventSocketWeb.Socket.Registry
  alias EventSocket.PubSub.Events

  @impl true
  def child_spec(_opts) do
    %{id: Task, start: {Task, :start_link, [fn -> :ok end]}, restart: :transient}
  end

  defmodule State do
    @type t :: %__MODULE__{
            id: integer,
            ping_timer: any
          }
    defstruct id: 0, ping_timer: nil
  end

  defmodule Reply do
    @derive Jason.Encoder
    defstruct metadata: %{}, payload: %{}

    def encoded(type, payload \\ %{}, metadata \\ %{}) do
      {:text,
       Jason.encode_to_iodata!(%Reply{
         metadata:
           Map.merge(
             %{message_id: Ecto.UUID.generate()},
             Map.merge(metadata, %{
               message_type: type,
               message_timestamp: DateTime.utc_now() |> DateTime.to_iso8601()
             })
           ),
         payload: payload
       })}
    end
  end

  @impl true
  def connect(%{params: %{"api_key" => api_key}}) do
    case EventSocket.Users.by_api_key(api_key) do
      nil ->
        {:error, "Invalid API key"}

      user ->
        {:ok,
         %State{
           id: user.id
         }}
    end
  end

  @impl true
  @spec init(State.t()) :: {:ok, State.t()}
  def init(state) do
    Registry.register()
    EventSocket.PubSub.subscribe_user_events(state.id)

    {:ok, state |> queue_ping}
  end

  def queue_ping(%State{} = state) do
    if !is_nil(state.ping_timer), do: Process.cancel_timer(state.ping_timer)

    %{state | ping_timer: Process.send_after(self(), :ping, 15000)}
  end

  @impl true
  def handle_info(data, state) do
    {:push, handle_event(data), state |> queue_ping}
  end

  def handle_event(%Events.User.EventsubNotification{} = data) do
    Reply.encoded(
      "notification",
      %{
        event: data.type,
        payload: data.event,
        condition: data.condition
      },
      %{
        message_id: data.id,
        subscription_type: data.type
      }
    )
  end

  def handle_event(:notify_shutdown) do
    Reply.encoded("websocket_reconnect")
  end

  def handle_event(:ping) do
    Reply.encoded("websocket_keepalive")
  end

  def notify_shutdown(pid) do
    send(pid, :notify_shutdown)
  end

  @impl true
  def handle_in(_in, state) do
    {:stop, :exit, state}
  end

  @impl true
  def terminate(_reason, _state) do
    :ok
  end
end
