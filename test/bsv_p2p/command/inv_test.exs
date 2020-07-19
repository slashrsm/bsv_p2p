defmodule BsvP2p.Command.InvTest do
  use ExUnit.Case
  alias BSV.Util
  alias BsvP2p.Command
  alias BsvP2p.Command.Inv
  alias BsvP2p.Util.InventoryVector
  doctest BsvP2p.Command.Inv

  test "Command.name/1" do
    assert BsvP2p.Command.name(%Inv{}) == "inv"
  end

  test "Command.get_payload/1" do
    hash = Util.random_bytes(32)

    assert <<1, 1, 0, 0, 0>> <> hash ==
             Command.get_payload(%Inv{vectors: [%InventoryVector{type: :transaction, hash: hash}]})

    assert <<2, 1, 0, 0, 0>> <> hash <> <<1, 0, 0, 0>> <> hash ==
             Command.get_payload(%Inv{
               vectors: [
                 %InventoryVector{type: :transaction, hash: hash},
                 %InventoryVector{type: :transaction, hash: hash}
               ]
             })

    assert <<1, 2, 0, 0, 0>> <> hash ==
             Command.get_payload(%Inv{vectors: [%InventoryVector{type: :block, hash: hash}]})
  end

  test "BsvP2p.Command.Inv.from_payload/1" do
    hash = Util.random_bytes(32)

    assert %Inv{vectors: [%InventoryVector{type: :transaction, hash: hash}]} ==
             Inv.from_payload(<<1, 1, 0, 0, 0>> <> hash)

    assert %Inv{
             vectors: [
               %InventoryVector{type: :transaction, hash: hash},
               %InventoryVector{type: :transaction, hash: hash}
             ]
           } == Inv.from_payload(<<2, 1, 0, 0, 0>> <> hash <> <<1, 0, 0, 0>> <> hash)

    assert %Inv{vectors: [%InventoryVector{type: :block, hash: hash}]} ==
             Inv.from_payload(<<1, 2, 0, 0, 0>> <> hash)
  end
end
