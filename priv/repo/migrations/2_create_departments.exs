defmodule Tracker.Repo.Migrations.CreateDepartments do
  use Ecto.Migration

  def change do
    create table(:departments) do
      add(:category, :string)
      add(:name, :string)
      add(:active, :boolean)
      add(:in_queue, :boolean)

      timestamps()
    end

    create(unique_index(:departments, [:category]))
  end
end
