defmodule EventSocket.Repo.Access.Users do
  import Ecto.Query, warn: false

  alias EventSocket.Repo.Schemas.User
  alias EventSocket.Repo

  @spec by_api_key(String.t()) :: User.t() | nil
  def by_api_key(key) do
    Repo.get_by(User, api_key_hash: :erlang.phash2(key))
  end
end
