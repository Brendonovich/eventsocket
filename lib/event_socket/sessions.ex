defmodule EventSocket.Sessions do
  alias EventSocket.Repo.{Mutations, Access}

  def create(user_id) do
    case Mutations.Sessions.create(user_id) do
      nil ->
        :error

      session ->
        {:ok, session.id}
    end
  end

  defdelegate get(id), to: Access.Sessions

  defdelegate delete(id), to: Mutations.Sessions
end
