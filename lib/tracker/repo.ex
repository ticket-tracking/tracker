defmodule Tracker.Repo do
  use Ecto.Repo,
    otp_app: :tracker,
    adapter: Ecto.Adapters.Postgres
end


defmodule Tracker.Repo.Helpers do
  @moduledoc false

  @doc false
  defmacro fetch_object(fun, args) do
    quote do
      case apply(__MODULE__, unquote(fun), unquote(args)) do
        nil -> {:error, :not_found}
        val -> {:ok, val}
      end
    end
  end
end
