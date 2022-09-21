defmodule EventSocket.Repo.Mutation.Socket do
  import Ecto.Query, warn: false

  alias EventSocket.Repo.Schema.Socket
  alias EventSocket.Repo

  def register!(user_id) do
    %Socket{}
    |> Socket.insert_changeset(%{
      user_id: user_id
    })
    |> Repo.insert!()
  end

  def delete(id), do: %Socket{id: id} |> Repo.delete()
end
