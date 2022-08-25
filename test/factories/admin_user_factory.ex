defmodule Tracker.AdminUserFactory do
  @moduledoc false

  alias Tracker.Admin.User

  @doc false
  defmacro __using__(_opts) do
    quote do
      def admin_user_factory do
        %User{
          email: sequence(:email, &"email-#{&1}@example.com"),
          encrypted_password: "password@123",
          role: sequence(:role, ["root", "admin"])
        }
      end
    end
  end
end
