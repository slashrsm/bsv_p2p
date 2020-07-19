defmodule BsvP2p.Command.MempoolTest do
  use ExUnit.Case
  alias BsvP2p.Command
  alias BsvP2p.Command.Mempool
  doctest BsvP2p.Command.Mempool

  test "Command.name/1" do
    assert Command.name(%Mempool{}) == "mempool"
  end

  test "Command.get_payload/1" do
    assert Command.get_payload(%Mempool{}) == <<>>
  end

  test "BsvP2p.Command.Mempool.from_payload/1" do
    assert Mempool.from_payload(<<>>) == %Mempool{}
  end
end
