defmodule Tracker.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false

  alias Tracker.Repo
  alias Ecto.{Changeset}
  alias Tracker.Ecto.Types.Pbkdf2Hash

  alias Tracker.Accounts.{
    Account,
    ChangePassword
  }

  @preload_always [:department]

  @spec create_admin(binary, binary, UUID.t()) ::
          {:ok, Account.t()} | {:error, Changeset.t()}
  def create_admin(password, email, acct_id) do
    %Account{
      type: "admin",
      acct_id: acct_id,
      status: "activated",
      password: password,
      email: email
    }
    |> Changeset.change()
    |> Repo.insert()
  end

  @spec create_account(Account.t(), map) :: {:ok, Account.t()} | {:error, Changeset.t()}
  def create_account(%Account{} = acct \\ %Account{}, attrs) do
    with {:ok, account} <- acct |> Account.changeset(attrs) |> Repo.insert() do
      {:ok, Repo.preload(account, @preload_always)}
    end
  end

  @spec update_account_status(Account.t(), map) :: {:ok, Account.t()} | {:error, Changeset.t()}
  def update_account_status(%Account{} = acct, attrs) do
    with {:ok, updated_acct} <- acct |> Account.status_changeset(attrs) |> Repo.update() do
      updated_acct = Repo.preload(updated_acct, @preload_always)
      {:ok, updated_acct}
    end
  end

  @spec update_account(Account.t(), map) :: {:ok, Account.t()} | {:error, Changeset.t()}
  def update_account(%Account{} = acct, attrs) do
    with {:ok, updated_acct} <- acct |> Account.update_changeset(attrs) |> Repo.update() do
      updated_acct = Repo.preload(updated_acct, @preload_always)
      {:ok, updated_acct}
    end
  end

  @spec update_account_pass(Account.t(), ChangePassword.t()) ::
          {:ok, Account.t()} | {:error, Changeset.t()}
  def update_account_pass(%Account{password: hash} = acct, %ChangePassword{} = pass) do
    case Pbkdf2Hash.verify(pass.password, hash) do
      true ->
        acct
        |> Account.password_changeset(%{password: pass.new_password})
        |> Repo.update()

      false ->
        changeset =
          acct
          |> change_account()
          |> Changeset.add_error(:password, "invalid")

        {:error, changeset}
    end
  end

  @spec change_account(Account.t()) :: Changeset.t()
  def change_account(%Account{} = acct) do
    Account.changeset(acct, %{})
  end

  @spec get_account_by_email(binary) :: {:ok, Account.t()} | {:error, :not_found}
  def get_account_by_email(email) do
    Account
    |> add_preload(:department)
    |> Repo.get_by(email: email)
  end

  @spec add_preload(Ecto.Queryable.t(), atom) :: Ecto.Query.t()
  def add_preload(query, :department) do
    from(q in query,
      left_join: dpart in assoc(q, :department),
      preload: [department: dpart]
    )
  end
end
