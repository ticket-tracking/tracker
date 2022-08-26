defmodule Tracker.InvestigationTests do
  use Tracker.DataCase, async: false

  alias Tracker.Investigation

  setup do
    insert_list(2, :investigation_department)
    :ok
  end

  describe "Investigation" do
    test "ok: return all investigation departments" do
      assert 2 == length(Investigation.list_investigation_departments())
    end

    test "update an investigation department" do
      %{name: name, active: active} = department = insert(:investigation_department)

      assert {:ok, %Tracker.Investigation.Department{name: ^name}} =
               Investigation.update_department(department, %{active: !active})
    end

    test "get department by category" do
      %{name: name, category: category} = insert(:investigation_department)

      assert %Tracker.Investigation.Department{name: ^name, category: ^category} =
               Investigation.get_department_by_category!(category)
    end

    test "throws an error for invalid category" do
      attrs = %{
        category: "plumbing",
        name: "Production Department",
        active: true,
        in_queue: true
      }

      assert {:error, changeset} = Investigation.create_department(attrs)
      assert errors_on(changeset)[:category] == ["is invalid"]
    end
  end
end
