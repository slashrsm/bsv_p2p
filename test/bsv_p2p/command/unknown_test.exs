defmodule BsvP2p.Command.UnknownTest do
  use ExUnit.Case
  alias BsvP2p.Command
  alias BsvP2p.Command.Unknown
  doctest BsvP2p.Command.Unknown

  test "Command.name/1" do
    assert BsvP2p.Command.name(%Unknown{name: "foo", payload: <<0xFF, 0xFF>>}) == "_unknown"
  end

  test "Command.get_payload/1" do
    assert Command.get_payload(%Unknown{name: "foo", payload: <<0xFF, 0xFF>>}) == <<>>
  end

  test "BsvP2p.Command.Unknown.from_payload/1" do
    assert %Unknown{name: "", payload: <<>>} == Unknown.from_payload(BSV.Util.random_bytes(8))
  end
end
