defmodule Tracker.Accounts.ChangePassword do
  @moduledoc """
  Change password validation schema.
  """

  use Ecto.Schema

  import Ecto.Changeset

  @typedoc "ChangePassword type"
  @type t :: %__MODULE__{}

  @fields [:password, :new_password]

  embedded_schema do
    field(:password, :string)
    field(:new_password, :string)
  end

  ## API

  @spec new(map()) :: {:ok, t} | {:error, Ecto.Changeset.t()}
  def new(params) when is_map(params) do
    changeset = changeset(params)

    if changeset.valid? do
      {:ok, apply_changes(changeset)}
    else
      {:error, changeset}
    end
  end

  ## Private functions

  defp changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> validate_length(:password, min: 4, max: 128)
    |> validate_length(:new_password, min: 4, max: 128)
  end
end
