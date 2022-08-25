defmodule Tracker.Admin do
  @moduledoc """
  The Admin context.
  """

  import Ecto.Query, warn: false

  alias Ecto.Changeset
  alias Tracker.Admin.User
  alias Tracker.Repo

  ## API

  @spec list_admin_users :: [User.t()]
  def list_admin_users do
    Repo.all(User)
  end

  @spec get_user!(integer) :: User.t()
  def get_user!(id), do: Repo.get!(User, id)

  @spec get_user(integer) :: User.t() | nil
  def get_user(id), do: Repo.get(User, id)

  @spec get_user_by_email(String.t()) :: User.t() | nil
  def get_user_by_email(nil), do: nil
  def get_user_by_email(email), do: Repo.get_by(User, email: email)

  @spec get_user_by_email!(String.t()) :: User.t()
  def get_user_by_email!(email), do: Repo.get_by!(User, email: email)

  @spec create_user(map) :: {:ok, User.t()} | {:error, Changeset.t()}
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @spec update_user(User.t(), map) :: {:ok, User.t()} | {:error, Changeset.t()}
  def update_user(%User{} = user, attrs) do
    user
    |> User.update_changeset(attrs)
    |> Repo.update()
  end

  @spec delete_user(User.t()) :: {:ok, User.t()} | {:error, Changeset.t()}
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @spec change_user(User.t(), map) :: Changeset.t()
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
