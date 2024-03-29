defmodule EventSocket.Repo.Access.User do
  import Ecto.Query, warn: false

  alias EventSocket.Repo.Schema.User
  alias EventSocket.Repo

  @spec by_api_key(String.t()) :: User.t() | nil
  def by_api_key(key) do
    Repo.get_by(User, api_key_hash: :erlang.phash2(key))
  end

  @spec by_id(integer()) :: User.t() | nil
  def by_id(id) do
    Repo.get_by(User, id: id)
  end

  def get_and_lock(id) do
    from(u in User,
      where: u.id == ^id,
      lock: "FOR UPDATE"
    )
    |> Repo.one()
  end
end
