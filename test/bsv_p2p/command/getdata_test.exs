defmodule BsvP2p.Command.GetdataTest do
  use ExUnit.Case
  alias BSV.Util
  alias BsvP2p.Command
  alias BsvP2p.Command.Getdata
  alias BsvP2p.Util.InventoryVector
  doctest BsvP2p.Command.Getdata

  test "Command.name/1" do
    assert BsvP2p.Command.name(%Getdata{}) == "getdata"
  end

  test "Command.get_payload/1" do
    hash = Util.random_bytes(32)

    assert <<1, 1, 0, 0, 0>> <> hash ==
             Command.get_payload(%Getdata{
               vectors: [%InventoryVector{type: :transaction, hash: hash}]
             })

    assert <<2, 1, 0, 0, 0>> <> hash <> <<1, 0, 0, 0>> <> hash ==
             Command.get_payload(%Getdata{
               vectors: [
                 %InventoryVector{type: :transaction, hash: hash},
                 %InventoryVector{type: :transaction, hash: hash}
               ]
             })

    assert <<1, 2, 0, 0, 0>> <> hash ==
             Command.get_payload(%Getdata{vectors: [%InventoryVector{type: :block, hash: hash}]})
  end

  test "BsvP2p.Command.Getdata.from_payload/1" do
    hash = Util.random_bytes(32)

    assert %Getdata{vectors: [%InventoryVector{type: :transaction, hash: hash}]} ==
             Getdata.from_payload(<<1, 1, 0, 0, 0>> <> hash)

    assert %Getdata{
             vectors: [
               %InventoryVector{type: :transaction, hash: hash},
               %InventoryVector{type: :transaction, hash: hash}
             ]
           } == Getdata.from_payload(<<2, 1, 0, 0, 0>> <> hash <> <<1, 0, 0, 0>> <> hash)

    assert %Getdata{vectors: [%InventoryVector{type: :block, hash: hash}]} ==
             Getdata.from_payload(<<1, 2, 0, 0, 0>> <> hash)
  end
end
