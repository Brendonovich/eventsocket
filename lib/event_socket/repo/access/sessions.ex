defmodule EventSocket.Repo.Access.Sessions do
  import Ecto.Query, warn: false

  alias EventSocket.Repo.Schemas.Session
  alias EventSocket.Repo

  def get(id) do
    Repo.get(Session, id)
  end
end
