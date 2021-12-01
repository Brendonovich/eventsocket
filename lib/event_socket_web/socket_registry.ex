defmodule EventSocketWeb.Socket.Registry do
  use GenServer

  alias EventSocketWeb.Socket

  @impl true
  def init(opts) do
    Process.flag(:trap_exit, true)
    {:ok, opts}
  end

  def start_link(_) do
    GenServer.start_link(
      EventSocketWeb.Socket.Registry,
      MapSet.new(),
      name: EventSocketWeb.Socket.Registry
    )
  end

  def register() do
    GenServer.call(EventSocketWeb.Socket.Registry, {:register, self()})
  end

  @impl true
  def handle_call({:register, pid}, _, state) do
    {:reply, :ok, MapSet.put(state, pid)}
  end

  @impl true
  def terminate(_reason, state) do
    for pid <- state do
      Socket.notify_shutdown(pid)
    end

    :ok
  end
end
