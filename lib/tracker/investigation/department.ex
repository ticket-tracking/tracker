defmodule Tracker.Investigation.Department do
  @moduledoc """
  Investigation Department schema.
  """
  use Ecto.Schema

  import Ecto.Changeset

  @typedoc "Department type"
  @type t :: %__MODULE__{}

  @fields [:category, :name, :active, :in_queue]

  @allowed_categories [
    "human-resources",
    "it",
    "accounting-and-finance",
    "marketing",
    "research-and-development",
    "production"
  ]

  schema "departments" do
    field :category, :string
    field :name, :string
    field :active, :boolean
    field :in_queue, :boolean

    timestamps()
  end

  @spec changeset(t, map) :: Ecto.Changeset.t()
  def changeset(department, attrs) do
    department
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> common_changeset()
  end

  @spec update_changeset(t, map) :: Ecto.Changeset.t()
  def update_changeset(department, attrs) do
    department
    |> cast(attrs, @fields -- [:category])
    |> validate_required(@fields -- [:category])
    |> common_changeset()
  end

  defp common_changeset(changeset) do
    changeset
    |> validate_length(:name, min: 12, max: 128)
    |> validate_inclusion(:category, @allowed_categories)
    |> unique_constraint(:category)
  end
end
