defmodule BsvP2p.Command.ProtoconfTest do
  use ExUnit.Case
  alias BsvP2p.Command
  alias BsvP2p.Command.Protoconf
  doctest BsvP2p.Command.Protoconf

  test "Command.name/1" do
    assert BsvP2p.Command.name(%Protoconf{max_recv_payload_length: 1}) == "protoconf"
  end

  test "Command.get_payload/1" do
    assert Command.get_payload(%Protoconf{}) == <<0x01, 0x00, 0x00, 0x20, 0x00>>

    assert Command.get_payload(%Protoconf{max_recv_payload_length: 1}) ==
             <<0x01, 0x01, 0x00, 0x00, 0x00>>
  end

  test "BsvP2p.Command.Protoconf.from_payload/1" do
    assert %Protoconf{max_recv_payload_length: 1} ==
             Protoconf.from_payload(<<0x01, 0x01, 0x00, 0x00, 0x00>>)

    assert %Protoconf{} == Protoconf.from_payload(<<0x01, 0x00, 0x00, 0x20, 0x00>>)
  end

  test "BsvP2p.Command.Protoconf.from_payload/1 fails if incorrect number of fields" do
    assert_raise FunctionClauseError, fn ->
      Protoconf.from_payload(<<0x00>>)
    end

    assert_raise FunctionClauseError, fn ->
      Protoconf.from_payload(<<0x02, 0x00, 0x00, 0x20, 0x00, 0xFF>>)
    end
  end
end
