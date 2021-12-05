defmodule EventSocket.Sockets do
  alias EventSocket.Repo.{Mutations, Access}
  alias EventSocket.Repo

  def register(user_id) do
    Repo.transaction(fn ->
      Access.Users.get_and_lock(user_id)

      case Access.Sockets.get_by_user(user_id) do
        [] -> Mutations.Sockets.register(user_id)
        _ -> {:error, :maximum_sockets_reached}
      end
    end)
    |> elem(1)
  end

  defdelegate delete!(id), to: Mutations.Sockets
end
