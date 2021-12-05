defmodule EventSocket.Sockets do
  alias EventSocket.Repo.{Mutations}

  defdelegate register!(user_id), to: Mutations.Sockets

  defdelegate delete(id), to: Mutations.Sockets
end
