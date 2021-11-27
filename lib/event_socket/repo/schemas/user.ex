defmodule EventSocket.Repo.Schemas.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias EventSocket.Repo.Schemas.Subscription

  @type t :: %__MODULE__{
          id: integer(),
          username: String.t(),
          display_name: String.t()
        }

  @primary_key {:id, :integer, []}

  schema "users" do
    field :username, :string
    field :display_name, :string
    field :api_key_hash, :integer, null: true

    has_many :subscriptions, Subscription
  end

  def insert_changeset(user, attrs) do
    user
    |> cast(attrs, [:id, :username])
    |> validate_required([:id, :username])
  end

  def edit_changeset(user, attrs) do
    user
    |> cast(attrs, [:api_key_hash])
  end
end
