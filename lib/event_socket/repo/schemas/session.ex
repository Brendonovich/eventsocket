defmodule EventSocket.Repo.Schemas.Session do
  use Ecto.Schema
  import Ecto.Changeset

  alias EventSocket.Repo.Schemas.User

  @primary_key {:id, Ecto.UUID, autogenerate: true}

  schema "sessions" do
    field :expires, :date

    belongs_to :user, User
  end

  def insert_changeset(session, attrs) do
    session
    |> cast(attrs, [:user_id, :expires])
    |> validate_required([:user_id, :expires])
  end

  def edit_changeset(user, attrs) do
    user
    |> cast(attrs, [:expires])
  end
end
