defmodule BsvP2p.Command.VerackTest do
  use ExUnit.Case
  alias BsvP2p.Command
  alias BsvP2p.Command.Verack
  doctest BsvP2p.Command.Verack

  test "Command.name/1" do
    assert Command.name(%Verack{}) == "verack"
  end

  test "Command.get_payload/1" do
    assert Command.get_payload(%Verack{}) == <<>>
  end

  test "BsvP2p.Command.Verack.from_payload/1" do
    assert Verack.from_payload(<<>>) == %Verack{}
  end
end
