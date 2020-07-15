defmodule BsvP2p.Command.PingTest do
  use ExUnit.Case
  alias BsvP2p.Command
  alias BsvP2p.Command.Ping
  doctest BsvP2p.Command.Ping

  test "Command.name/1" do
    assert BsvP2p.Command.name(%Ping{nonce: BSV.Util.random_bytes(8)}) == "ping"
  end

  test "Command.get_payload/1" do
    nonce = BSV.Util.random_bytes(8)
    assert Command.get_payload(%Ping{nonce: nonce}) == nonce
  end

  test "BsvP2p.Command.Ping.from_payload/1" do
    nonce = BSV.Util.random_bytes(8)
    result = Ping.from_payload(nonce)
    assert %Ping{nonce: nonce} == result
  end

  test "BsvP2p.Command.Ping.from_payload/1 fails if incorrect nonce size" do
    assert_raise FunctionClauseError, fn ->
      Ping.from_payload(BSV.Util.random_bytes(4))
    end

    assert_raise FunctionClauseError, fn ->
      Ping.from_payload(BSV.Util.random_bytes(12))
    end
  end
end
