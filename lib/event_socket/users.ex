defmodule EventSocket.Users do
  alias EventSocket.Repo.Users

  @spec by_api_key(String.t()) :: nil | EventSocket.Repo.Schemas.User.t()
  defdelegate by_api_key(api_key), to: Users

  defdelegate generate_api_key(user_id), to: Users
end
