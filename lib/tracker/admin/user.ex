defmodule Tracker.Admin.User do
  @moduledoc """
  Admin user schema.
  """
  use Ecto.Schema

  import Ecto.Changeset

  @email_regex ~r/^[\w.!#$%&’*+\-\/=?\^`{|}~]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*$/i

  @typedoc "Account type"
  @type t :: %__MODULE__{}

  schema "admin_users" do
    field :encrypted_password, :string
    field :role, :string
    field :email, :string

    timestamps()
  end

  @spec changeset(t, map) :: Ecto.Changeset.t()
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :encrypted_password, :role])
    |> validate_required([:email, :encrypted_password, :role])
    |> common_changeset()
    |> update_change(:encrypted_password, &Bcrypt.hash_pwd_salt/1)
  end

  @spec update_changeset(t, map) :: Ecto.Changeset.t()
  def update_changeset(user, attrs) do
    user
    |> cast(attrs, [:encrypted_password])
    |> validate_required([:encrypted_password])
    |> validate_confirmation(:encrypted_password)
    |> common_changeset()
    |> update_change(:encrypted_password, &Bcrypt.hash_pwd_salt/1)
  end

  defp common_changeset(changeset) do
    changeset
    |> validate_format(:email, @email_regex)
    |> validate_length(:encrypted_password, min: 8, max: 128)
    |> validate_format(
      :encrypted_password,
      ~r/^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9].*[0-9])(?=.*[a-z].*[a-z].*[a-z]).{8,}$/
    )
    |> validate_inclusion(:role, ["root", "admin"])
    |> unique_constraint(:email)
  end
end
