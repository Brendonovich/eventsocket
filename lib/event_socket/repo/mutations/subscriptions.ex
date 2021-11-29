defmodule EventSocket.Repo.Mutations.Subscriptions do
  import Ecto.Query, warn: false

  alias EventSocket.Repo.Schemas.Subscription
  alias EventSocket.Repo

  @spec create(map) :: any
  def create(data) do
    %Subscription{}
    |> Subscription.insert_changeset(data)
    |> Repo.insert()
  end

  @spec update(String.t(), String.t(), map, map) :: any
  def update(
        type,
        user_id,
        condition,
        data
      ) do
    %Subscription{
      type: type,
      condition: condition,
      user_id: user_id
    }
    |> Subscription.edit_changeset(data)
    |> Repo.update()
  end

  def set_status(id, status) do
    %Subscription{
      id: id
    }
    |> Subscription.edit_changeset(%{status: status})
    |> Repo.update()
  end

  @spec delete_by_id(String.t()) :: any
  def delete_by_id(id) do
    from(s in Subscription, where: s.id == ^id) |> Repo.delete_all()
  end

  def delete_by_hash(hash) do
    from(s in Subscription, where: s.hash == ^hash) |> Repo.delete_all()
  end
end
