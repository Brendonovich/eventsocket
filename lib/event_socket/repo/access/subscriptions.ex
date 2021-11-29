defmodule EventSocket.Repo.Access.Subscriptions do
  import Ecto.Query, warn: false

  alias EventSocket.Repo.Schemas.Subscription
  alias EventSocket.Repo

  @spec all(integer()) :: list(Subscription.t())
  def all(user_id) do
    Repo.all(from s in Subscription, where: s.user_id == ^user_id)
  end

  def exists?(type, condition) do
    Repo.exists?(from s in Subscription, where: s.type == ^type and s.condition == ^condition)
  end
end
