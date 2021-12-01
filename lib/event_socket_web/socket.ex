defmodule EventSocketWeb.Socket do
  @behaviour Phoenix.Socket.Transport

  alias EventSocketWeb.Socket.Registry

  @impl true
  def child_spec(_opts) do
    %{id: Task, start: {Task, :start_link, [fn -> :ok end]}, restart: :transient}
  end

  defmodule State do
    @type t :: %__MODULE__{
            id: integer
          }
    defstruct id: 0
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
    EventSocket.PubSub.subscribe("user_events:#{state.id}")

    {:ok, state}
  end

  @impl true
  def handle_info({:eventsub_event, data}, state) do
    {:push,
     resp(%{
       type: "notification",
       payload: %{
         event: data.type,
         payload: data.event,
         condition: data.condition
       }
     }), state}
  end

  @impl true
  def handle_info(:notify_shutdown, state) do
    {:push,
     resp(%{
       type: "websocket_reconnect"
     }), state}
  end

  defp resp(data) when is_map(data) do
    {:text, Jason.encode_to_iodata!(data)}
  end

  def notify_shutdown(pid) do
    send(pid, :notify_shutdown)
  end

  @impl true
  def handle_in(_in, state) do
    {:ok, state}
  end

  @impl true
  def terminate(_reason, _state) do
    :ok
  end
end
