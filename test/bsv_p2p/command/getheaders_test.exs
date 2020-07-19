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

    assert "o\xE2\x8C\n\xB6\xF1\xB3r\xC1\xA6\xA2F\xAEc\xF7O\x93\x1E\x83e\xE1Z\b\x9Ch\xD6\x19\0\0\0\0\0" ==
             command.stop

    assert "\d\x11\x01\0\x01\0\0\0\0\0\x19\xD6h\x9C\bZ\xE1e\x83\x1E\x93O\xF7c\xAEF\xA2\xA6\xC1r\xB3\xF1\xB6\n\x8C\xE2oo\xE2\x8C\n\xB6\xF1\xB3r\xC1\xA6\xA2F\xAEc\xF7O\x93\x1E\x83e\xE1Z\b\x9Ch\xD6\x19\0\0\0\0\0" ==
             Command.get_payload(command)
  end

  test "BsvP2p.Command.Getheaders.set_locator_hashes/2" do
    command =
      %Getheaders{}
      |> Getheaders.set_locator_hashes(
        "00000000839A8E6886AB5951D76F411475428AFC90947EE320161BBF18EB6048"
      )

    assert [
             "H`\xEB\x18\xBF\e\x16 \xE3~\x94\x90\xFC\x8ABu\x14Ao\xD7QY\xAB\x86h\x8E\x9A\x83\0\0\0\0"
           ] == command.locator_hashes

    assert "\d\x11\x01\0\x01H`\xEB\x18\xBF\e\x16 \xE3~\x94\x90\xFC\x8ABu\x14Ao\xD7QY\xAB\x86h\x8E\x9A\x83\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0" ==
             Command.get_payload(command)

    command =
      %Getheaders{}
      |> Getheaders.set_locator_hashes([
        "00000000839A8E6886AB5951D76F411475428AFC90947EE320161BBF18EB6048",
        "000000006A625F06636B8BB6AC7B960A8D03705D1ACE08B1A19DA3FDCC99DDBD"
      ])

    assert [
             "H`\xEB\x18\xBF\e\x16 \xE3~\x94\x90\xFC\x8ABu\x14Ao\xD7QY\xAB\x86h\x8E\x9A\x83\0\0\0\0",
             "\xBDݙ\xCC\xFD\xA3\x9D\xA1\xB1\b\xCE\x1A]p\x03\x8D\n\x96{\xAC\xB6\x8Bkc\x06_bj\0\0\0\0"
           ] == command.locator_hashes

    assert "\d\x11\x01\0\x02\xBDݙ\xCC\xFD\xA3\x9D\xA1\xB1\b\xCE\x1A]p\x03\x8D\n\x96{\xAC\xB6\x8Bkc\x06_bj\0\0\0\0H`\xEB\x18\xBF\e\x16 \xE3~\x94\x90\xFC\x8ABu\x14Ao\xD7QY\xAB\x86h\x8E\x9A\x83\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0" ==
             Command.get_payload(command)
  end
end
