defmodule Tracker.TypesTest do
  use ExUnit.Case

  alias Tracker.Ecto.Types.{Pbkdf2Hash}
  alias Pbkdf2.Base64

  describe "pbkdf2 type" do
    test "Ecto.Type callbacks" do
      {:ok, pbkdf2} = Pbkdf2Hash.dump("test")
      {:ok, ^pbkdf2} = Pbkdf2Hash.load(pbkdf2)

      refute "test" == pbkdf2
      refute Pbkdf2Hash.verify("invalid", pbkdf2)
      assert Pbkdf2Hash.verify("test", pbkdf2)
    end

    test "Ecto.Type callbacks with pbkdf2 string" do
      {:ok, pbkdf2} = Pbkdf2Hash.dump("test")

      assert Pbkdf2Hash.dump(pbkdf2) == {:ok, pbkdf2}
      assert Pbkdf2Hash.verify("test", pbkdf2)

      assert_raise ArgumentError, ~r"expected a valid pbkdf2 hash, got:", fn ->
        Pbkdf2Hash.dump("$pbkdf2-invalid")
      end
    end

    test "modular_crypt_format/4 with default params" do
      {:ok, pbkdf2} = Pbkdf2Hash.dump("test")

      [_alg, _rounds, salt, hash] = String.split(pbkdf2, "$", trim: true)
      decoded_salt = Base64.decode(salt)
      hash = hash |> Base64.decode() |> Base.encode64()

      assert Pbkdf2Hash.modular_crypt_format(hash, decoded_salt) == pbkdf2
      assert Pbkdf2Hash.modular_crypt_format(hash, salt) == pbkdf2

      assert Pbkdf2Hash.verify("test", pbkdf2)
    end

    test "modular_crypt_format/4 with custom params" do
      pass = "1234"
      salt = "3BF7EXS1zGo8x/kWDlp5njcEChc="

      pbkdf2 = Pbkdf2.Base.hash_password(pass, salt, rounds: 1000, length: 40, format: :django)
      [_alg, _rounds, _salt, hash] = String.split(pbkdf2, "$", trim: true)

      assert formatted_pbkdf2 = Pbkdf2Hash.modular_crypt_format(hash, salt, "sha512", 1000)
      assert Pbkdf2Hash.verify("1234", formatted_pbkdf2)
    end
  end
end
