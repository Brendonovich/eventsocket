defmodule EventSocket.Repo.Migrations.Init do
  use Ecto.Migration

  def change do
    create table("user", primary_key: false) do
      add :id, :integer, primary_key: true
      add :display_name, :string
      add :api_key_hash, :integer, null: true
    end

    create table("subscription", primary_key: false) do
      add :id, :uuid, null: true
      add :status, :string
      add :type, :string
      add :hash, :integer, primary_key: true
      add :user_id, references("user")
    end

    create table("session", primary_key: false) do
      add :id, :uuid, primary_key: true, null: false
      add :expires, :date
      add :user_id, references("user")
    end

    create table("socket", primary_key: false) do
      add :id, :uuid, primary_key: true
      add :user_id, references("user")

      timestamps()
    end
  end
end
