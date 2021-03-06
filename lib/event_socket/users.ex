defmodule EventSocket.Users do
  alias EventSocket.Repo.{Users}
  alias EventSocket.Repo.Schemas.User
  alias EventSocket.UserServer

  @spec by_api_key(String.t()) :: nil | User.t()
  defdelegate by_api_key(api_key), to: Users

  @spec by_id(integer()) :: nil | User.t()
  defdelegate by_id(id), to: Users

  defdelegate generate_api_key(user_id), to: Users

  @spec get_or_create_user(%{id: integer, display_name: String.t()}) :: User.t()
  def get_or_create_user(data) do
    user =
      case Users.by_id(data.id) do
        nil ->
          Users.create(data)

        user ->
          user
      end

    UserServer.Supervisor.ensure_running(user.id)

    user
  end

  def is_premium?(_user_id), do: true
end
