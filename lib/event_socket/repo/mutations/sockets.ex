defmodule EventSocket.Repo.Mutations.Sockets do
  import Ecto.Query, warn: false

  alias EventSocket.Repo.Schemas.Socket
  alias EventSocket.Repo

  def register(user_id) do
    %Socket{}
    |> Socket.insert_changeset(%{
      user_id: user_id
    })
    |> Repo.insert()
  end

  def delete!(id), do: %Socket{id: id} |> Repo.delete!()
end
