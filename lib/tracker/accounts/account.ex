defmodule Tracker.Accounts.Account do
  @moduledoc """
  Account Schema.
  """

  use Ecto.Schema

  import Ecto.Changeset

  @email_regex ~r/^[\w.!#$%&’*+\-\/=?\^`{|}~]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*$/i

  @typedoc "Account type"
  @type t :: %__MODULE__{}

  @permitted [
    :acct_id,
    :password,
    :email,
    :type,
    :status
  ]

  @required [
    :email,
    :type,
    :status
  ]

  @encode [:department | List.delete(@permitted, :password)]

  ## Schema

  @derive [{Jason.Encoder, only: @encode}, {Msgpax.Packer, fields: @encode}]
  schema "accounts" do
    field(:acct_id, Ecto.UUID, autogenerate: true)
    field(:password, Tracker.Ecto.Types.Pbkdf2Hash)
    field(:email, :string)
    field(:type, :string, default: "individual.customer")
    field(:status, :string, default: "unapproved")
    belongs_to(:department, Tracker.Investigation.Department)

    timestamps()
  end

  ## API

  @spec changeset(t, map) :: Ecto.Changeset.t()
  def changeset(account, attrs) do
    account
    |> cast(attrs, @permitted)
    |> validate_inclusion(:status, statuses())
    |> validate_common()
  end

  @spec update_changeset(t, map) :: Ecto.Changeset.t()
  def update_changeset(account, attrs) do
    account
    |> cast(attrs, @permitted -- [:status, :password])
    |> validate_common()
  end

  @spec password_changeset(t, map) :: Ecto.Changeset.t()
  def password_changeset(account, attrs) do
    account
    |> cast(attrs, [:password])
    |> validate_required([:password])
    |> validate_length(:password, min: 4, max: 128)
  end

  @spec status_changeset(t, map) :: Ecto.Changeset.t()
  def status_changeset(account, attrs) do
    account
    |> cast(attrs, [:status])
    |> validate_required([:status])
    |> validate_inclusion(:status, statuses())
  end

  ## Helpers

  @spec types :: [String.t(), ...]
  def types do
    [
      "individual.customer",
      "individual.agent"
    ]
  end

  @spec statuses :: [String.t(), ...]
  def statuses do
    [
      "online",
      "offline",
      "engagged",
      "dnd",
      "approved",
      "activated",
      "deactivated",
      "suspended",
      "blacklisted",
      "terminated",
      "unapproved"
    ]
  end

  ## Private Functions

  defp validate_common(changeset) do
    changeset
    |> cast_assoc(:department)
    |> validate_required(@required)
    |> validate_length(:password, min: 4, max: 128)
    |> validate_format(:email, @email_regex)
    |> validate_inclusion(:type, types())
    |> unique_constraint(:acct_id, name: :accounts_acct_id_index)
    |> unique_constraint(:email, name: :accounts_email_index)
  end
end
