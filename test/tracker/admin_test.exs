defmodule Tracker.AdminTests do
  use Tracker.DataCase, async: false

  alias Tracker.Admin

  setup do
    insert_list(10, :admin_user)
    :ok
  end

  describe "admin" do
    test "ok: list all admin users" do
      assert 10 == length(Admin.list_admin_users)
    end
  end
end
