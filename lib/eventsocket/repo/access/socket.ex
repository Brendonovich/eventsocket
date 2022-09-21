defmodule EventSocket.Repo.Access.Socket do
  import Ecto.Query, warn: false

  alias EventSocket.Repo.Schema.Socket
  alias EventSocket.Repo

  @spec by_user(integer()) :: list(Socket.t())
  def by_user(user_id) do
    from(s in Socket,
      where:
        s.user_id ==
          ^user_id
    )
    |> Repo.all()
  end
end
