defmodule BsvP2p.Command.HeadersTest do
  use ExUnit.Case
  alias BSV.Block
  alias BSV.Crypto.Hash
  alias BsvP2p.Command
  alias BsvP2p.Command.Headers
  doctest BsvP2p.Command.Headers

  test "Command.name/1" do
    assert BsvP2p.Command.name(%Headers{}) == "headers"
  end

  test "Command.get_payload/1" do
    assert "\0" == Command.get_payload(%Headers{})

    assert "\x02\x01\0\0\0o\xE2\x8C\n\xB6\xF1\xB3r\xC1\xA6\xA2F\xAEc\xF7O\x93\x1E\x83e\xE1Z\b\x9Ch\xD6\x19\0\0\0\0\0\x98 Q\xFD\x1EK\xA7D\xBB\xBEh\x0E\x1F\xEE\x14g{\xA1\xA3\xC3T\v\xF7\xB1Ͷ\x06\xE8W#>\x0Ea\xBCfI\xFF\xFF\0\x1D\x01\xE3b\x99\0\x01\0\0\0H`\xEB\x18\xBF\e\x16 \xE3~\x94\x90\xFC\x8ABu\x14Ao\xD7QY\xAB\x86h\x8E\x9A\x83\0\0\0\0\xD5\xFD\xCCT\x1E%\xDE\x1CzZ\xDD\xED\xF2HX\xB8\xBBf\\\x9F6\xEFtN\xE4,1`\"\xC9\x0F\x9B\xB0\xBCfI\xFF\xFF\0\x1D\bҽa\0" ==
             %Headers{
               headers: [
                 Block.parse(
                   "010000006FE28C0AB6F1B372C1A6A246AE63F74F931E8365E15A089C68D6190000000000982051FD1E4BA744BBBE680E1FEE14677BA1A3C3540BF7B1CDB606E857233E0E61BC6649FFFF001D01E36299",
                   encoding: :hex
                 )
                 |> elem(0),
                 Block.parse(
                   "010000004860EB18BF1B1620E37E9490FC8A427514416FD75159AB86688E9A8300000000D5FDCC541E25DE1C7A5ADDEDF24858B8BB665C9F36EF744EE42C316022C90F9BB0BC6649FFFF001D08D2BD61",
                   encoding: :hex
                 )
                 |> elem(0)
               ]
             }
             |> Command.get_payload()
  end

  test "Command.get_payload/1 with transaction count" do
    {header, ""} =
      Block.parse(
        "010000006FE28C0AB6F1B372C1A6A246AE63F74F931E8365E15A089C68D6190000000000982051FD1E4BA744BBBE680E1FEE14677BA1A3C3540BF7B1CDB606E857233E0E61BC6649FFFF001D01E36299",
        encoding: :hex
      )

    assert "\x01\x01\0\0\0o\xE2\x8C\n\xB6\xF1\xB3r\xC1\xA6\xA2F\xAEc\xF7O\x93\x1E\x83e\xE1Z\b\x9Ch\xD6\x19\0\0\0\0\0\x98 Q\xFD\x1EK\xA7D\xBB\xBEh\x0E\x1F\xEE\x14g{\xA1\xA3\xC3T\v\xF7\xB1Ͷ\x06\xE8W#>\x0Ea\xBCfI\xFF\xFF\0\x1D\x01\xE3b\x99\x03" ==
             %Headers{
               headers: [
                 %{
                   header
                   | transactions: [
                       Hash.sha256_sha256("fake_tx"),
                       Hash.sha256_sha256("another_fake_tx"),
                       Hash.sha256_sha256("some_more")
                     ]
                 }
               ]
             }
             |> Command.get_payload()
  end

  test "BsvP2p.Command.Headers.from_payload/1" do
    assert %Headers{} == Headers.from_payload("\0")

    assert %Headers{
             headers: [
               Block.parse(
                 "010000006FE28C0AB6F1B372C1A6A246AE63F74F931E8365E15A089C68D6190000000000982051FD1E4BA744BBBE680E1FEE14677BA1A3C3540BF7B1CDB606E857233E0E61BC6649FFFF001D01E36299",
                 encoding: :hex
               )
               |> elem(0),
               Block.parse(
                 "010000004860EB18BF1B1620E37E9490FC8A427514416FD75159AB86688E9A8300000000D5FDCC541E25DE1C7A5ADDEDF24858B8BB665C9F36EF744EE42C316022C90F9BB0BC6649FFFF001D08D2BD61",
                 encoding: :hex
               )
               |> elem(0)
             ]
           } ==
             Headers.from_payload(
               "\x02\x01\0\0\0o\xE2\x8C\n\xB6\xF1\xB3r\xC1\xA6\xA2F\xAEc\xF7O\x93\x1E\x83e\xE1Z\b\x9Ch\xD6\x19\0\0\0\0\0\x98 Q\xFD\x1EK\xA7D\xBB\xBEh\x0E\x1F\xEE\x14g{\xA1\xA3\xC3T\v\xF7\xB1Ͷ\x06\xE8W#>\x0Ea\xBCfI\xFF\xFF\0\x1D\x01\xE3b\x99\0\x01\0\0\0H`\xEB\x18\xBF\e\x16 \xE3~\x94\x90\xFC\x8ABu\x14Ao\xD7QY\xAB\x86h\x8E\x9A\x83\0\0\0\0\xD5\xFD\xCCT\x1E%\xDE\x1CzZ\xDD\xED\xF2HX\xB8\xBBf\\\x9F6\xEFtN\xE4,1`\"\xC9\x0F\x9B\xB0\xBCfI\xFF\xFF\0\x1D\bҽa\0"
             )
  end
end
