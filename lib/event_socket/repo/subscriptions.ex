defmodule EventSocket.Repo.Subscriptions do
  alias EventSocket.Repo.{Mutations, Access}

  defdelegate all_subscriptions, to: Access.Subscriptions
  @spec exists?(String.t(), map) :: boolean
  defdelegate exists?(type, condition), to: Access.Subscriptions

  defdelegate create(data), to: Mutations.Subscriptions
  defdelegate update(type, user_id, condition, data), to: Mutations.Subscriptions
  defdelegate delete_by_id(id), to: Mutations.Subscriptions
  defdelegate delete_by_hash(hash), to: Mutations.Subscriptions
end
