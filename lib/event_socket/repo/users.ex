defmodule EventSocket.Repo.Users do
  alias EventSocket.Repo.Mutations
  alias EventSocket.Repo.Access

  @spec by_api_key(String.t()) :: nil | EventSocket.Repo.Schemas.User.t()
  defdelegate by_api_key(api_key), to: Access.Users

  defdelegate generate_api_key(user_id), to: Mutations.Users
end
