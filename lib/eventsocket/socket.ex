defmodule EventSocket.Socket do
  alias EventSocket.Repo.{Mutation, Access}

  defdelegate register!(user_id), to: Mutation.Socket
  defdelegate delete(id), to: Mutation.Socket

  defdelegate by_user(user_id), to: Access.Socket
end
