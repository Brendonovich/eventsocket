defmodule EventSocket.Repo.Mutations.Events do
  import Ecto.Query, warn: false

  alias EventSocket.Repo.Schemas.Event
  alias EventSocket.Repo

  def create(data) do
    %Event{}
    |> Event.insert_changeset(data)
    |> Repo.insert!()
  end
end
