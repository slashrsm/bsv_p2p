defmodule BsvP2p.Command.PongTest do
  use ExUnit.Case
  alias BsvP2p.Command
  alias BsvP2p.Command.Pong
  doctest BsvP2p.Command.Pong

  test "Command.name/1" do
    assert BsvP2p.Command.name(%Pong{nonce: BSV.Util.random_bytes(8)}) == "pong"
  end

  test "Command.get_payload/1" do
    nonce = BSV.Util.random_bytes(8)
    assert Command.get_payload(%Pong{nonce: nonce}) == nonce
  end

  test "BsvP2p.Command.Pong.from_payload/1" do
    nonce = BSV.Util.random_bytes(8)
    result = Pong.from_payload(nonce)
    assert %Pong{nonce: nonce} == result
  end

  test "BsvP2p.Command.Pong.from_payload/1 fails if incorrect nonce size" do
    assert_raise FunctionClauseError, fn ->
      Pong.from_payload(BSV.Util.random_bytes(4))
    end

    assert_raise FunctionClauseError, fn ->
      Pong.from_payload(BSV.Util.random_bytes(12))
    end
  end
end
