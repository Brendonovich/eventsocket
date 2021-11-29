defmodule EventSocket.Repo.Schemas.Subscription do
  use Ecto.Schema
  import Ecto.Changeset

  alias EventSocket.Repo.Schemas.User

  @type t :: %__MODULE__{
          id: String.t(),
          status: String.t(),
          condition: map,
          type: String.t()
        }

  @primary_key false
  @derive {Jason.Encoder, only: [:id, :status, :type, :condition]}
  schema "subscriptions" do
    field :id, Ecto.UUID, null: true
    field :status, :string
    field :type, :string
    field :condition, :map
    field :hash, :integer, primary_key: true

    belongs_to :user, User

    # timestamps()
  end

  def hash(subscription) do
    :erlang.phash2(%{
      condition: subscription.condition,
      type: subscription.type,
      user_id: subscription.user_id
    })
  end

  @doc false
  def insert_changeset(subscription, attrs) do
    subscription_hash = hash(attrs)
    attrs = Map.put(attrs, :hash, subscription_hash)

    subscription
    |> cast(attrs, [:type, :condition, :user_id, :hash])
    |> validate_required([:type, :condition, :user_id])
    |> unique_constraint([:type, :condition, :user_id], name: :subscriptions_pkey)
  end

  def edit_changeset(subscription, attrs) do
    subscription
    |> Map.put(:hash, hash(subscription))
    |> cast(attrs, [:id, :status])
  end
end
