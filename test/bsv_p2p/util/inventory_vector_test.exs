defmodule BsvP2p.Util.InventoryVectorTest do
  use ExUnit.Case
  alias BSV.Util
  alias BsvP2p.Util.InventoryVector

  test "BsvP2p.Util.InventoryVector.get_payload/1" do
    hash = Util.random_bytes(32)

    assert <<0, 0, 0, 0>> <> hash ==
             InventoryVector.get_payload(%InventoryVector{type: :error, hash: hash})

    assert <<1, 0, 0, 0>> <> hash ==
             InventoryVector.get_payload(%InventoryVector{type: :transaction, hash: hash})

    assert <<2, 0, 0, 0>> <> hash ==
             InventoryVector.get_payload(%InventoryVector{type: :block, hash: hash})

    assert <<3, 0, 0, 0>> <> hash ==
             InventoryVector.get_payload(%InventoryVector{type: :filtered_block, hash: hash})

    assert <<4, 0, 0, 0>> <> hash ==
             InventoryVector.get_payload(%InventoryVector{type: :compact_block, hash: hash})
  end

  test "BsvP2p.Util.Services.from_payload/1" do
    hash = Util.random_bytes(32)

    assert %InventoryVector{type: :error, hash: hash} ==
             InventoryVector.from_payload(<<0, 0, 0, 0>> <> hash)

    assert %InventoryVector{type: :transaction, hash: hash} ==
             InventoryVector.from_payload(<<1, 0, 0, 0>> <> hash)

    assert %InventoryVector{type: :block, hash: hash} ==
             InventoryVector.from_payload(<<2, 0, 0, 0>> <> hash)

    assert %InventoryVector{type: :filtered_block, hash: hash} ==
             InventoryVector.from_payload(<<3, 0, 0, 0>> <> hash)

    assert %InventoryVector{type: :compact_block, hash: hash} ==
             InventoryVector.from_payload(<<4, 0, 0, 0>> <> hash)
  end
end
