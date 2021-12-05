defmodule EventSocket.Repo.Migrations.Websocket do
  use Ecto.Migration

  def change do
    create table("sockets", primary_key: false) do
      add :id, :uuid, primary_key: true
      add :user_id, references("users")

      timestamps()
    end
  end
end
