defmodule BsvP2p.Command.NotfoundTest do
  use ExUnit.Case
  alias BSV.Util
  alias BsvP2p.Command
  alias BsvP2p.Command.Notfound
  alias BsvP2p.Util.InventoryVector
  doctest BsvP2p.Command.Notfound

  test "Command.name/1" do
    assert BsvP2p.Command.name(%Notfound{}) == "notfound"
  end

  test "Command.get_payload/1" do
    hash = Util.random_bytes(32)

    assert <<1, 1, 0, 0, 0>> <> hash ==
             Command.get_payload(%Notfound{
               vectors: [%InventoryVector{type: :transaction, hash: hash}]
             })

    assert <<2, 1, 0, 0, 0>> <> hash <> <<1, 0, 0, 0>> <> hash ==
             Command.get_payload(%Notfound{
               vectors: [
                 %InventoryVector{type: :transaction, hash: hash},
                 %InventoryVector{type: :transaction, hash: hash}
               ]
             })

    assert <<1, 2, 0, 0, 0>> <> hash ==
             Command.get_payload(%Notfound{vectors: [%InventoryVector{type: :block, hash: hash}]})
  end

  test "BsvP2p.Command.Notfound.from_payload/1" do
    hash = Util.random_bytes(32)

    assert %Notfound{vectors: [%InventoryVector{type: :transaction, hash: hash}]} ==
             Notfound.from_payload(<<1, 1, 0, 0, 0>> <> hash)

    assert %Notfound{
             vectors: [
               %InventoryVector{type: :transaction, hash: hash},
               %InventoryVector{type: :transaction, hash: hash}
             ]
           } == Notfound.from_payload(<<2, 1, 0, 0, 0>> <> hash <> <<1, 0, 0, 0>> <> hash)

    assert %Notfound{vectors: [%InventoryVector{type: :block, hash: hash}]} ==
             Notfound.from_payload(<<1, 2, 0, 0, 0>> <> hash)
  end
end
