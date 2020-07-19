defmodule BsvP2p.Command.GetaddrTest do
  use ExUnit.Case
  alias BsvP2p.Command
  alias BsvP2p.Command.Getaddr
  doctest BsvP2p.Command.Getaddr

  test "Command.name/1" do
    assert Command.name(%Getaddr{}) == "getaddr"
  end

  test "Command.get_payload/1" do
    assert Command.get_payload(%Getaddr{}) == <<>>
  end

  test "BsvP2p.Command.Getaddr.from_payload/1" do
    assert Getaddr.from_payload(<<>>) == %Getaddr{}
  end
end
