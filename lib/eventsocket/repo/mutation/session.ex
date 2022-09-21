defmodule EventSocket.Repo.Mutation.Session do
  import Ecto.Query, warn: false

  alias EventSocket.Repo.Schema.Session
  alias EventSocket.Repo

  @spec create(integer()) :: Session.t()
  def create(user_id) do
    %Session{}
    |> Session.insert_changeset(%{user_id: user_id, expires: Date.utc_today() |> Date.add(14)})
    |> Repo.insert!()
  end

  def delete(id) do
    %Session{id: id}
    |> Repo.delete()
  end
end
