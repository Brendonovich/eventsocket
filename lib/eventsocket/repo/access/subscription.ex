defmodule EventSocket.Repo.Access.Subscription do
  import Ecto.Query, warn: false

  alias EventSocket.Repo.Schema.Subscription
  alias EventSocket.Repo

  @spec by_user(integer()) :: list(Subscription.t())
  def by_user(user_id) do
    Repo.all(from s in Subscription, where: s.user_id == ^user_id)
  end

  def exists?(type, condition) do
    Repo.exists?(from s in Subscription, where: s.type == ^type and s.condition == ^condition)
  end
end
