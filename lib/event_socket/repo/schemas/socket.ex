defmodule EventSocket.Repo.Schemas.Socket do
  use Ecto.Schema
  import Ecto.Changeset

  alias EventSocket.Repo.Schemas.User

  @primary_key {:id, Ecto.UUID, autogenerate: true}

  schema "sockets" do
    belongs_to :user, User

    timestamps()
  end

  def insert_changeset(socket, attrs) do
    socket
    |> cast(attrs, [:user_id])
    |> validate_required([:user_id])
  end
end
