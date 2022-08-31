defmodule Tracker.Ecto.Types.Pbkdf2Hash do
  @moduledoc false

  use Ecto.Type

  alias Pbkdf2.Base64

  ## Ecto.Type Callbacks

  @impl true
  def type, do: :pbkdf2_hash

  @impl true
  def cast(value), do: {:ok, to_string(value)}

  @impl true
  def load(value), do: {:ok, value}

  @impl true
  def dump("$pbkdf2-" <> rest = value) do
    case String.split(rest, "$", trim: true) do
      [alg, rounds, salt, hash] when alg in ["sha512", "sha256"] ->
        {:ok, modular_crypt_format(hash, salt, alg, String.to_integer(rounds))}

      _ ->
        raise ArgumentError, "expected a valid pbkdf2 hash, got: #{inspect(value)}"
    end
  end

  def dump(value) do
    password =
      value
      |> to_string()
      |> Pbkdf2.hash_pwd_salt()

    {:ok, password}
  end

  ## Helpers

  @spec verify(binary, binary) :: boolean
  defdelegate verify(string, hash), to: Pbkdf2, as: :verify_pass

  @spec modular_crypt_format(binary, binary, binary, integer) :: binary
  def modular_crypt_format(hash, salt, alg \\ "sha512", rounds \\ 160_000) do
    "$pbkdf2-#{alg}$#{rounds}$#{enc_base64(salt)}$#{maybe_enc_base64(hash)}"
  end

  defp maybe_enc_base64(string) do
    case Base.decode64(string) do
      {:ok, value} ->
        Base64.encode(value)

      :error ->
        enc_base64(string)
    end
  end

  defp enc_base64(string) do
    _ = Base64.decode(string)
    string
  rescue
    _ -> Base64.encode(string)
  end
end
