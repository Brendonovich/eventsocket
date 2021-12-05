defmodule EventSocket.UserServer.Supervisor do
  use Horde.DynamicSupervisor

  alias EventSocket.{UserServer, UserServer.Registry}

  def start_link(_) do
    Horde.DynamicSupervisor.start_link(
      __MODULE__,
      [strategy: :one_for_one],
      name: __MODULE__
    )
  end

  def init(init_arg) do
    [members: members()]
    |> Keyword.merge(init_arg)
    |> Horde.DynamicSupervisor.init()
  end

  defp members() do
    [Node.self() | Node.list()]
    |> Enum.map(fn node -> {__MODULE__, node} end)
  end

  @spec ensure_running(integer) :: nil | pid()
  def ensure_running(user_id) do
    case Horde.Registry.lookup(Registry, user_id) do
      [] ->
        {:ok, pid} =
          Horde.DynamicSupervisor.start_child(
            __MODULE__,
            %{
              id: UserServer,
              start: {UserServer, :start_link, [user_id]}
            }
          )

        pid

      _ ->
        nil
    end
  end
end
