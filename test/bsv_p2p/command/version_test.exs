defmodule BsvP2p.Command.VersionTest do
  use ExUnit.Case
  alias BsvP2p.Command
  alias BsvP2p.Command.Version
  import Mock
  doctest BsvP2p.Command.Version

  @test_payload <<205, 129, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 97, 188, 102, 73, 0, 0, 0, 0, 1, 0, 0,
                  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255, 255, 127, 0, 0, 1, 32, 141, 1,
                  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255, 255, 127, 0, 0, 1, 32,
                  141, 1, 2, 3, 4, 5, 6, 7, 8, 15, 47, 98, 115, 118, 95, 112, 50, 112, 58, 48, 46,
                  48, 46, 48, 47, 241, 251, 9, 0, 1>>

  test "Command.name/1" do
    assert Command.name(%Version{}) == "version"
  end

  test "Command.get_payload/1" do
    assert @test_payload ==
             Command.get_payload(%Version{
               version: 98_765,
               services: [:node_network],
               nonce: <<0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08>>,
               timestamp: ~U[2009-01-09 02:54:25Z],
               user_agent: "/bsv_p2p:0.0.0/",
               latest_block: 654_321,
               recipient: %BsvP2p.Util.NetworkAddress{
                 ip: "127.0.0.1",
                 port: 8333,
                 services: [:node_network]
               },
               sender: %BsvP2p.Util.NetworkAddress{
                 ip: "127.0.0.1",
                 port: 8333,
                 services: [:node_network]
               },
               relay: true
             })

    assert String.slice(@test_payload, 0, byte_size(@test_payload) - 2) <> <<0x00>> ==
             Command.get_payload(%Version{
               version: 98_765,
               services: [:node_network],
               nonce: <<0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08>>,
               timestamp: ~U[2009-01-09 02:54:25Z],
               user_agent: "/bsv_p2p:0.0.0/",
               latest_block: 654_321,
               recipient: %BsvP2p.Util.NetworkAddress{
                 ip: "127.0.0.1",
                 port: 8333,
                 services: [:node_network]
               },
               sender: %BsvP2p.Util.NetworkAddress{
                 ip: "127.0.0.1",
                 port: 8333,
                 services: [:node_network]
               },
               relay: false
             })
  end

  test "BsvP2p.Command.Version.from_payload/1" do
    with_mock DateTime,
      utc_now: fn -> ~U[2009-01-09 02:54:25Z] end,
      from_unix!: fn 1_231_469_665 -> ~U[2009-01-09 02:54:25Z] end do
      assert %Version{
               version: 98_765,
               services: [:node_network],
               nonce: <<0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08>>,
               timestamp: ~U[2009-01-09 02:54:25Z],
               user_agent: "/bsv_p2p:0.0.0/",
               latest_block: 654_321,
               recipient: %BsvP2p.Util.NetworkAddress{
                 ip: "127.0.0.1",
                 port: 8333,
                 services: [:node_network],
                 timestamp: ~U[2009-01-09 02:54:25Z]
               },
               sender: %BsvP2p.Util.NetworkAddress{
                 ip: "127.0.0.1",
                 port: 8333,
                 services: [:node_network],
                 timestamp: ~U[2009-01-09 02:54:25Z]
               },
               relay: true
             } == Version.from_payload(@test_payload)

      assert %Version{
               version: 98_765,
               services: [:node_network],
               nonce: <<0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08>>,
               timestamp: ~U[2009-01-09 02:54:25Z],
               user_agent: "/bsv_p2p:0.0.0/",
               latest_block: 654_321,
               recipient: %BsvP2p.Util.NetworkAddress{
                 ip: "127.0.0.1",
                 port: 8333,
                 services: [:node_network],
                 timestamp: ~U[2009-01-09 02:54:25Z]
               },
               sender: %BsvP2p.Util.NetworkAddress{
                 ip: "127.0.0.1",
                 port: 8333,
                 services: [:node_network],
                 timestamp: ~U[2009-01-09 02:54:25Z]
               },
               relay: false
             } ==
               Version.from_payload(
                 String.slice(@test_payload, 0, byte_size(@test_payload) - 2) <> <<0x00>>
               )
    end
  end
end
