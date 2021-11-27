defmodule EventSocket.Repo.Access.Subscriptions do
  import Ecto.Query, warn: false

  alias EventSocket.Repo.Schemas.Subscription
  alias EventSocket.Repo

  def all_subscriptions() do
    Repo.all(Subscription)
  end

  def exists?(type, condition) do
    Repo.exists?(from s in Subscription, where: s.type == ^type and s.condition == ^condition)
  end
end
