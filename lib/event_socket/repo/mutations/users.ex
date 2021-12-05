defmodule EventSocket.Repo.Mutations.Users do
  import Ecto.Query, warn: false

  alias EventSocket.Repo.Schemas.User
  alias EventSocket.Repo

  def generate_api_key(user_id) do
    new_api_key = Ecto.UUID.generate()

    %User{
      id: user_id
    }
    |> User.edit_changeset(%{
      api_key_hash: :erlang.phash2(new_api_key)
    })
    |> Repo.update()

    new_api_key
  end

  @spec create(map) :: User.t()
  def create(data) do
    %User{}
    |> User.insert_changeset(data)
    |> Repo.insert!()
  end
end
