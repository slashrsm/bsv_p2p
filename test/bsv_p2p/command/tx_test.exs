defmodule BsvP2p.Command.TxTest do
  use ExUnit.Case
  alias BSV.Transaction
  alias BsvP2p.Command
  alias BsvP2p.Command.Tx
  doctest BsvP2p.Command.Tx

  @transaction "01000000010000000000000000000000000000000000000000000000000000000000000000FFFFFFFF0704FFFF001D0104FFFFFFFF0100F2052A0100000043410496B538E853519C726A2C91E61EC11600AE1390813A627C66FB8BE7947BE63C52DA7589379515D4E0A604F8141781E62294721166BF621E73A82CBF2342C858EEAC00000000"

  test "Command.name/1" do
    assert BsvP2p.Command.name(%Tx{
             transaction: Transaction.parse(@transaction, encoding: :hex) |> elem(0)
           }) == "tx"
  end

  test "Command.get_payload/1" do
    assert "\x01\0\0\0\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xFF\xFF\xFF\xFF\a\x04\xFF\xFF\0\x1D\x01\x04\xFF\xFF\xFF\xFF\x01\0\xF2\x05*\x01\0\0\0CA\x04\x96\xB58\xE8SQ\x9Crj,\x91\xE6\x1E\xC1\x16\0\xAE\x13\x90\x81:b|f\xFB\x8B\xE7\x94{\xE6<R\xDAu\x897\x95\x15\xD4\xE0\xA6\x04\xF8\x14\x17\x81\xE6\"\x94r\x11f\xBFb\x1Es\xA8,\xBF#B\xC8X\xEE\xAC\0\0\0\0" ==
             Command.get_payload(%Tx{
               transaction: Transaction.parse(@transaction, encoding: :hex) |> elem(0)
             })
  end

  test "BsvP2p.Command.Tx.from_payload/1" do
    assert %Tx{transaction: Transaction.parse(@transaction, encoding: :hex) |> elem(0)} ==
             Tx.from_payload(
               "\x01\0\0\0\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xFF\xFF\xFF\xFF\a\x04\xFF\xFF\0\x1D\x01\x04\xFF\xFF\xFF\xFF\x01\0\xF2\x05*\x01\0\0\0CA\x04\x96\xB58\xE8SQ\x9Crj,\x91\xE6\x1E\xC1\x16\0\xAE\x13\x90\x81:b|f\xFB\x8B\xE7\x94{\xE6<R\xDAu\x897\x95\x15\xD4\xE0\xA6\x04\xF8\x14\x17\x81\xE6\"\x94r\x11f\xBFb\x1Es\xA8,\xBF#B\xC8X\xEE\xAC\0\0\0\0"
             )
  end
end
