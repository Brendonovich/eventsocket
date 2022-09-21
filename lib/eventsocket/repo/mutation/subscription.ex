defmodule EventSocket.Repo.Mutation.Subscription do
  import Ecto.Query, warn: false

  alias EventSocket.Repo.Schema.Subscription
  alias EventSocket.Repo

  @spec create(String.t(), integer()) :: any
  def create(type, user_id) do
    %Subscription{}
    |> Subscription.insert_changeset(%{
      type: type,
      user_id: user_id
    })
    |> Repo.insert()
  end

  @spec update(String.t(), integer(), map) :: any
  def update(
        type,
        user_id,
        data
      ) do
    %Subscription{
      type: type,
      user_id: user_id
    }
    |> Subscription.edit_changeset(data)
    |> Repo.update()
  end

  def set_status(id, status) do
    from(s in Subscription, where: s.id == ^id, update: [set: [status: ^status]])
    |> Repo.update_all([])
  end

  @spec delete_by_id(String.t()) :: any
  def delete_by_id(id) do
    from(s in Subscription, where: s.id == ^id) |> Repo.delete_all()
  end

  def delete(type, user_id) do
    from(s in Subscription, where: s.type == ^type and s.user_id == ^user_id) |> Repo.delete_all()
  end
end
