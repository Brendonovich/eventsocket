defmodule EventSocketWeb.Socket.TerminationRegistry do
  use GenServer

  alias EventSocketWeb.Socket

  @impl true
  def init(opts) do
    Process.flag(:trap_exit, true)
    {:ok, opts}
  end

  def start_link(_) do
    GenServer.start_link(
      __MODULE__,
      MapSet.new(),
      name: __MODULE__
    )
  end

  def register(), do: GenServer.call(__MODULE__, :register)
  def unregister(), do: GenServer.call(__MODULE__, :unregister)

  @impl true
  def handle_call(:register, {pid, _}, state) do
    {:reply, :ok, MapSet.put(state, pid)}
  end

  @impl true
  def handle_call(:unregister, {pid, _}, state) do
    {:reply, :ok, MapSet.delete(state, pid)}
  end

  @impl true
  def terminate(_reason, state) do
    for pid <- state do
      Socket.notify_shutdown(pid)
    end

    :ok
  end
end
