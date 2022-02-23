defmodule EventSocket.Repo.Subscriptions do
  alias EventSocket.Repo.{Mutations, Access}

  defdelegate all(user_id), to: Access.Subscriptions
  @spec exists?(String.t(), map) :: boolean
  defdelegate exists?(type, condition), to: Access.Subscriptions

  defdelegate create(type, user_id), to: Mutations.Subscriptions
  defdelegate update(type, user_id, data), to: Mutations.Subscriptions
  defdelegate delete_by_id(id), to: Mutations.Subscriptions
  defdelegate delete(type, user_id), to: Mutations.Subscriptions
end
