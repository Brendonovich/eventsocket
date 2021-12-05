defmodule EventSocket.Repo.Access.Sockets do
  import Ecto.Query, warn: false

  alias EventSocket.Repo.Schemas.Socket
  alias EventSocket.Repo

  def get_by_user(user_id) do
    from(s in Socket,
      where:
        s.user_id ==
          ^user_id
    )
    |> Repo.all()
  end
end
