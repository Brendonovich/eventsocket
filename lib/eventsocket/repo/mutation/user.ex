defmodule EventSocket.Repo.Mutation.User do
  import Ecto.Query, warn: false

  alias EventSocket.Repo.Schema.User
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

  def create(data) do
    %User{}
    |> User.insert_changeset(data)
    |> Repo.insert()
  end
end
