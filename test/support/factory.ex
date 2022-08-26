defmodule Tracker.Factory do
  @moduledoc false
  use ExMachina.Ecto, repo: Tracker.Repo
  use Tracker.AdminUserFactory
  use Tracker.InvestigationDepartmentFactory
end
