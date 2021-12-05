defmodule EventSocket.UserServer do
  use GenServer

  alias EventSocket.{UserServer, Sockets, Repo}

  defmodule State do
    @type t :: %__MODULE__{
            id: integer,
            sockets: MapSet.t()
          }

    defstruct id: 0, sockets: MapSet.new()
  end

  def start_link(user_id) do
    GenServer.start_link(__MODULE__, user_id, name: via_tuple(user_id))
  end

  @impl true
  def init(user_id) do
    sockets =
      user_id
      |> Repo.Access.Sockets.get_by_user()
      |> Enum.map(fn e -> e.id end)

    IO.inspect("Starting User Server")
    IO.inspect(sockets)

    {:ok,
     %State{
       id: user_id,
       sockets: MapSet.new(sockets)
     }}
  end

  # Public API

  def register_socket(user_id), do: call(user_id, :register_socket)
  def unregister_socket(user_id, id), do: call(user_id, {:unregister_socket, id})

  # Private Implementations

  @impl true
  def handle_call(:register_socket, _from, %State{} = state) do
    case MapSet.size(state.sockets) do
      0 ->
        socket = Sockets.register!(state.id)

        {:reply, {:ok, socket}, %State{state | sockets: MapSet.put(state.sockets, socket.id)}}

      _ ->
        {:reply, {:error, :maximum_sockets_reached}, state}
    end
  end

  def handle_call({:unregister_socket, id}, _from, %State{} = state) do
    Sockets.delete(id)

    {:reply, :ok, %State{state | sockets: MapSet.delete(state.sockets, id)}}
  end

  defp call(user_id, term) do
    user_id
    |> get_server
    |> GenServer.call(term)
  end

  defp get_server(user_id) do
    case UserServer.Supervisor.ensure_running(user_id) do
      nil ->
        user_id
        |> via_tuple()

      pid ->
        pid
    end
  end

  def via_tuple(user_id), do: {:via, Horde.Registry, {UserServer.Registry, user_id}}
end
