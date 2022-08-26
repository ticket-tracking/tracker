defmodule Tracker.InvestigationDepartmentFactory do
  @moduledoc false

  alias Tracker.Investigation.Department

  @doc false
  defmacro __using__(_opts) do
    quote do
      def investigation_department_factory do
        %Department{
          category:
            sequence(:category, [
              "human-resources",
              "it",
              "accounting-and-finance",
              "marketing",
              "research-and-development",
              "production"
            ]),
          name: sequence(:name, &"ABC #{&1} City Council"),
          in_queue: sequence(:in_queue, [true, false]),
          active: sequence(:active, [true, false])
        }
      end
    end
  end
end
