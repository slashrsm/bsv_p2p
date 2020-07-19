defmodule BsvP2p.Command.GetheadersTest do
  use ExUnit.Case
  alias BsvP2p.Command
  alias BsvP2p.Command.Getheaders
  doctest BsvP2p.Command.Getheaders

  @test_payload <<127, 17, 1, 0, 1, 0, 0, 0, 0, 0, 25, 214, 104, 156, 8, 90, 225, 101, 131, 30,
                  147, 79, 247, 99, 174, 70, 162, 166, 193, 114, 179, 241, 182, 10, 140, 226, 111,
                  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                  0, 0, 0, 0, 0>>

  test "Command.name/1" do
    assert BsvP2p.Command.name(%Getheaders{}) == "getheaders"
  end

  test "Command.get_payload/1" do
    assert Command.get_payload(%Getheaders{}) == @test_payload
  end

  test "BsvP2p.Command.Getheaders.from_payload/1" do
    assert %Getheaders{
             version: 70_015,
             locator_hashes: [
               Base.decode16!("000000000019D6689C085AE165831E934FF763AE46A2A6C172B3F1B60A8CE26F")
             ],
             stop: <<0::integer-size(256)-little>>
           } == Getheaders.from_payload(@test_payload)
  end

  test "BsvP2p.Command.Getheaders.set_stop_hash/2" do
    command = %Getheaders{} |> Getheaders.set_stop_hash(0)
    assert <<0::integer-size(256)-little>> == command.stop
    assert @test_payload == Command.get_payload(command)

    command =
      %Getheaders{}
      |> Getheaders.set_stop_hash(
        "000000000019D6689C085AE165831E934FF763AE46A2A6C172B3F1B60A8CE26F"
      )

    assert "\0\0\0\0\0\x19\xD6h\x9C\bZ\xE1e\x83\x1E\x93O\xF7c\xAEF\xA2\xA6\xC1r\xB3\xF1\xB6\n\x8C\xE2o" ==
             command.stop

    assert "\d\x11\x01\0\x01\0\0\0\0\0\x19\xD6h\x9C\bZ\xE1e\x83\x1E\x93O\xF7c\xAEF\xA2\xA6\xC1r\xB3\xF1\xB6\n\x8C\xE2o\0\0\0\0\0\x19\xD6h\x9C\bZ\xE1e\x83\x1E\x93O\xF7c\xAEF\xA2\xA6\xC1r\xB3\xF1\xB6\n\x8C\xE2o" ==
             Command.get_payload(command)
  end

  test "BsvP2p.Command.Getheaders.set_locator_hashes/2" do
    command =
      %Getheaders{}
      |> Getheaders.set_locator_hashes(
        "00000000839A8E6886AB5951D76F411475428AFC90947EE320161BBF18EB6048"
      )

    assert [
             "\0\0\0\0\x83\x9A\x8Eh\x86\xABYQ\xD7oA\x14uB\x8A\xFC\x90\x94~\xE3 \x16\e\xBF\x18\xEB`H"
           ] == command.locator_hashes

    assert "\d\x11\x01\0\x01\0\0\0\0\x83\x9A\x8Eh\x86\xABYQ\xD7oA\x14uB\x8A\xFC\x90\x94~\xE3 \x16\e\xBF\x18\xEB`H\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0" ==
             Command.get_payload(command)

    command =
      %Getheaders{}
      |> Getheaders.set_locator_hashes([
        "00000000839A8E6886AB5951D76F411475428AFC90947EE320161BBF18EB6048",
        "000000006A625F06636B8BB6AC7B960A8D03705D1ACE08B1A19DA3FDCC99DDBD"
      ])

    assert [
             "\0\0\0\0\x83\x9A\x8Eh\x86\xABYQ\xD7oA\x14uB\x8A\xFC\x90\x94~\xE3 \x16\e\xBF\x18\xEB`H",
             <<0, 0, 0, 0, 106, 98, 95, 6, 99, 107, 139, 182, 172, 123, 150, 10, 141, 3, 112, 93,
               26, 206, 8, 177, 161, 157, 163, 253, 204, 153, 221, 189>>
           ] == command.locator_hashes

    assert "\d\x11\x01\0\x02\0\0\0\0jb_\x06ck\x8B\xB6\xAC{\x96\n\x8D\x03p]\x1A\xCE\b\xB1\xA1\x9D\xA3\xFD̙ݽ\0\0\0\0\x83\x9A\x8Eh\x86\xABYQ\xD7oA\x14uB\x8A\xFC\x90\x94~\xE3 \x16\e\xBF\x18\xEB`H\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0" ==
             Command.get_payload(command)
  end
end
