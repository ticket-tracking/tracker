defmodule Tracker.Repo.Migrations.CreateAdminUsers do
  use Ecto.Migration

  def change do
    create table(:admin_users) do
      add(:email, :string)
      add(:encrypted_password, :string)
      add(:role, :string)

      timestamps()
    end

    create(unique_index(:admin_users, [:email]))
  end
end
