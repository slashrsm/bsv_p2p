defmodule BsvP2p.Command.SendheadersTest do
  use ExUnit.Case
  alias BsvP2p.Command
  alias BsvP2p.Command.Sendheaders
  doctest BsvP2p.Command.Sendheaders

  test "Command.name/1" do
    assert Command.name(%Sendheaders{}) == "sendheaders"
  end

  test "Command.get_payload/1" do
    assert Command.get_payload(%Sendheaders{}) == <<>>
  end

  test "BsvP2p.Command.Sendheaders.from_payload/1" do
    assert Sendheaders.from_payload(<<>>) == %Sendheaders{}
  end
end
