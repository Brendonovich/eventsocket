defmodule EventSocket.User do
  alias EventSocket.Repo.{Mutation, Access}
  alias EventSocket.UserServer

  defdelegate by_api_key(api_key), to: Access.User

  @spec by_id(integer()) :: nil | User.t()
  defdelegate by_id(id), to: Access.User

  defdelegate generate_api_key(user_id), to: Mutation.User

  @spec get_or_create_user(%{id: integer, display_name: String.t()}) :: User.t()
  def get_or_create_user(data) do
    user =
      case Access.User.by_id(data.id) do
        nil ->
          Mutation.User.create(data)

        user ->
          user
      end

    UserServer.Supervisor.ensure_running(user.id)

    user
  end
end
