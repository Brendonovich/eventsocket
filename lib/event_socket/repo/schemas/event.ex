defmodule EventSocket.Repo.Schemas.Event do
  use Ecto.Schema
  import Ecto.Changeset

  alias EventSocket.Repo.Schemas.User

  @primary_key false

  schema "events" do
    field :id, :string, primary_key: true
    field :raw, :map

    belongs_to :user, User
  end

  def insert_changeset(event, attrs) do
    event
    |> cast(attrs, [:user_id, :id, :raw])
    |> validate_required([:user_id, :id, :raw])
  end
end
