defmodule EventSocket.Session do
  alias EventSocket.Repo.{Access, Mutation}

  def create(user_id) do
    case Mutation.Session.create(user_id) do
      nil ->
        :error

      session ->
        {:ok, session.id}
    end
  end

  defdelegate get(id), to: Access.Session

  defdelegate delete(id), to: Mutation.Session
end
