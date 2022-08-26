defmodule Tracker.Investigation do
  @moduledoc """
  The Investigation context.
  """

  import Ecto.Query, warn: false

  alias Ecto.Changeset
  alias Tracker.Investigation.Department
  alias Tracker.Repo

  ## API

  @spec list_investigation_departments :: [Department.t()]
  def list_investigation_departments do
    Repo.all(Department)
  end

  @spec get_department_by_category(String.t()) :: Department.t() | nil
  def get_department_by_category(nil), do: nil
  def get_department_by_category(category), do: Repo.get_by(Department, category: category)

  @spec get_department_by_category!(String.t()) :: Department.t()
  def get_department_by_category!(category), do: Repo.get_by!(Department, category: category)

  @spec create_department(map) :: {:ok, Department.t()} | {:error, Changeset.t()}
  def create_department(attrs \\ %{}) do
    %Department{}
    |> Department.changeset(attrs)
    |> Repo.insert()
  end

  @spec update_department(Department.t(), map) :: {:ok, Department.t()} | {:error, Changeset.t()}
  def update_department(%Department{} = department, attrs) do
    department
    |> Department.update_changeset(attrs)
    |> Repo.update()
  end
end
