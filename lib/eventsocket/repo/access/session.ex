defmodule EventSocket.Repo.Access.Session do
  import Ecto.Query, warn: false

  alias EventSocket.Repo.Schema.Session

  def get(id) do
    EventSocket.Repo.get(Session, id)
  end
end
