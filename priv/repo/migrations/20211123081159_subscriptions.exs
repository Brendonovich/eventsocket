defmodule EventSocket.Repo.Migrations.Subscriptions do
  use Ecto.Migration

  def change do
    create table("users", primary_key: false) do
      add :id, :integer, primary_key: true
      add :display_name, :string
      add :username, :string
      add :api_key_hash, :integer, null: true
    end

    create table("subscriptions", primary_key: false) do
      add :id, :uuid, null: true
      add :status, :string
      add :type, :string
      add :condition, :map
      add :hash, :integer, primary_key: true
      add :user_id, references("users")
    end
  end
end
