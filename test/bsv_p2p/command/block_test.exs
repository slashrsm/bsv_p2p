defmodule BsvP2p.Command.BlockTest do
  use ExUnit.Case
  alias BsvP2p.Command
  alias BsvP2p.Command.Block
  doctest BsvP2p.Command.Block

  @block "010000006FE28C0AB6F1B372C1A6A246AE63F74F931E8365E15A089C68D6190000000000982051FD1E4BA744BBBE680E1FEE14677BA1A3C3540BF7B1CDB606E857233E0E61BC6649FFFF001D01E362990101000000010000000000000000000000000000000000000000000000000000000000000000FFFFFFFF0704FFFF001D0104FFFFFFFF0100F2052A0100000043410496B538E853519C726A2C91E61EC11600AE1390813A627C66FB8BE7947BE63C52DA7589379515D4E0A604F8141781E62294721166BF621E73A82CBF2342C858EEAC00000000"
  @payload "\x01\0\0\0o\xE2\x8C\n\xB6\xF1\xB3r\xC1\xA6\xA2F\xAEc\xF7O\x93\x1E\x83e\xE1Z\b\x9Ch\xD6\x19\0\0\0\0\0\x98 Q\xFD\x1EK\xA7D\xBB\xBEh\x0E\x1F\xEE\x14g{\xA1\xA3\xC3T\v\xF7\xB1Ͷ\x06\xE8W#>\x0Ea\xBCfI\xFF\xFF\0\x1D\x01\xE3b\x99\x01\x01\0\0\0\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xFF\xFF\xFF\xFF\a\x04\xFF\xFF\0\x1D\x01\x04\xFF\xFF\xFF\xFF\x01\0\xF2\x05*\x01\0\0\0CA\x04\x96\xB58\xE8SQ\x9Crj,\x91\xE6\x1E\xC1\x16\0\xAE\x13\x90\x81:b|f\xFB\x8B\xE7\x94{\xE6<R\xDAu\x897\x95\x15\xD4\xE0\xA6\x04\xF8\x14\x17\x81\xE6\"\x94r\x11f\xBFb\x1Es\xA8,\xBF#B\xC8X\xEE\xAC\0\0\0\0"

  test "Command.name/1" do
    assert BsvP2p.Command.name(%Block{
             block: BSV.Block.parse(@block, true, encoding: :hex) |> elem(0)
           }) == "block"
  end

  test "Command.get_payload/1" do
    assert @payload ==
             Command.get_payload(%Block{
               block: BSV.Block.parse(@block, true, encoding: :hex) |> elem(0)
             })
  end

  test "BsvP2p.Command.Block.from_payload/1" do
    assert %Block{block: BSV.Block.parse(@block, true, encoding: :hex) |> elem(0)} ==
             Block.from_payload(@payload)
  end
end
