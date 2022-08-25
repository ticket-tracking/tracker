defmodule Tracker.AdminTests do
  use Tracker.DataCase, async: false

  alias Tracker.Admin

  setup do
    insert_list(10, :admin_user)
    :ok
  end

  describe "admin" do
    test "ok: list all admin users" do
      assert 10 == length(Admin.list_admin_users())
    end

    test "creates an admin" do
      attrs = %{
        email: "john@wick.com",
        encrypted_password: "Password123@",
        role: "root"
      }

      assert {:ok, %Tracker.Admin.User{email: "john@wick.com", role: "root"}} =
               Admin.create_user(attrs)
    end

    test "updates an admin" do
      %{email: email} = admin = insert(:admin_user)

      assert {:ok, %Tracker.Admin.User{email: ^email}} =
               Admin.update_user(admin, %{encrypted_password: "Somenew123@"})
    end

    test "deletes an admin" do
      admin = insert(:admin_user)

      assert {:ok, _user} = Admin.delete_user(admin)
    end

    test "get user by email" do
      %{email: email} = insert(:admin_user)

      assert %Tracker.Admin.User{email: ^email} = Admin.get_user_by_email!(email)
    end

    test "throws an error for invalid role" do
      attrs = %{
        email: "john@wick.com",
        encrypted_password: "Password123@",
        role: "dev"
      }

      assert {:error, changeset} = Admin.create_user(attrs)
      assert errors_on(changeset)[:role] == ["is invalid"]
    end
  end
end
