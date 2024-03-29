defmodule EventSocket.Repo.Schema.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias EventSocket.Repo.Schema.{Session, Subscription}

  @type t :: %__MODULE__{
          id: integer(),
          display_name: String.t()
        }

  @primary_key {:id, :integer, []}

  schema "user" do
    field :display_name, :string
    field :api_key_hash, :integer

    has_many :subscriptions, Subscription
    has_many :sessions, Session
  end

  def insert_changeset(user, attrs) do
    user
    |> cast(attrs, [:id, :display_name])
    |> validate_required([:id, :display_name])
  end

  def edit_changeset(user, attrs) do
    user
    |> cast(attrs, [:api_key_hash])
  end
end
