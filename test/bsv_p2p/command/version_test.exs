defmodule BsvP2p.Command.VersionTest do
  use ExUnit.Case
  alias BsvP2p.Command
  alias BsvP2p.Command.Version
  doctest BsvP2p.Command.Version

  @test_payload <<205, 129, 1, 0, 1, 2, 255, 238, 170, 187, 17, 34, 97, 188, 102, 73, 0, 0, 0, 0,
                  1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255, 255, 127, 0, 0, 1,
                  32, 141, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255, 255, 127, 0,
                  0, 1, 32, 141, 1, 2, 3, 4, 5, 6, 7, 8, 15, 47, 98, 115, 118, 95, 112, 50, 112,
                  58, 48, 46, 48, 46, 48, 47, 241, 251, 9, 0>>

  test "Command.name/1" do
    assert Command.name(%Version{}) == "version"
  end

  test "Command.get_payload/1" do
    version = %Version{
      version: 98_765,
      services: <<0x01, 0x02, 0xFF, 0xEE, 0xAA, 0xBB, 0x11, 0x22>>,
      nonce: <<0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08>>,
      timestamp: ~U[2009-01-09 02:54:25Z],
      user_agent: "/bsv_p2p:0.0.0/",
      latest_block: 654_321,
      recipient: nil,
      sender: nil
    }

    assert @test_payload == Command.get_payload(version)
  end

  test "BsvP2p.Command.Verack.from_payload/1" do
    assert %Version{
             version: 98_765,
             services: <<0x01, 0x02, 0xFF, 0xEE, 0xAA, 0xBB, 0x11, 0x22>>,
             nonce: <<0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08>>,
             timestamp: ~U[2009-01-09 02:54:25Z],
             user_agent: "/bsv_p2p:0.0.0/",
             latest_block: 654_321,
             recipient: nil,
             sender: nil
           } == Version.from_payload(@test_payload)
  end
end
