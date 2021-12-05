defmodule EventSocket.Repo.Users do
  alias EventSocket.Repo.Mutations
  alias EventSocket.Repo.Access
  alias EventSocket.Repo.Schemas.User

  @spec by_api_key(String.t()) :: nil | User.t()
  defdelegate by_api_key(api_key), to: Access.Users

  @spec by_id(integer()) :: nil | User.t()
  defdelegate by_id(id), to: Access.Users

  defdelegate generate_api_key(user_id), to: Mutations.Users

  defdelegate create(data), to: Mutations.Users

  defdelegate get_and_lock(id), to: Access.Users
end
