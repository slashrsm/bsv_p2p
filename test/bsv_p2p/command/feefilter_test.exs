defmodule BsvP2p.Command.FeefilterTest do
  use ExUnit.Case
  alias BsvP2p.Command
  alias BsvP2p.Command.Feefilter
  doctest BsvP2p.Command.Feefilter

  test "Command.name/1" do
    assert BsvP2p.Command.name(%Feefilter{fee: 250}) == "feefilter"
  end

  test "Command.get_payload/1" do
    assert Command.get_payload(%Feefilter{fee: 250}) == <<0xFA, 0, 0, 0, 0, 0, 0, 0>>
  end

  test "BsvP2p.Command.Ping.from_payload/1" do
    assert %Feefilter{fee: 1050} == Feefilter.from_payload(<<0x1A, 0x04, 0, 0, 0, 0, 0, 0>>)
  end
end
