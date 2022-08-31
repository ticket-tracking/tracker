defmodule Tracker.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add(:acct_id, :uuid, unique: true, null: false)
      add(:email, :string, unique: true)
      add(:password, :string)
      add(:type, :string)
      add(:status, :string)
      add(:department_id, references(:departments, on_delete: :nothing))

      timestamps()
    end

    create(unique_index(:accounts, [:department_id], name: :accounts_department_id_index))
    create(unique_index(:accounts, [:acct_id], name: :accounts_acct_id_index))
    create(unique_index(:accounts, [:email], name: :accounts_email_index))
  end
end
