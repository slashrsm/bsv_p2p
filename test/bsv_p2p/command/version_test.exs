defmodule BsvP2p.Command.VersionTest do
  use ExUnit.Case
  alias BsvP2p.Command
  alias BsvP2p.Command.Version
  doctest BsvP2p.Command.Version

  @test_payload <<205, 129, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 97, 188, 102, 73, 0, 0, 0, 0, 1, 0, 0,
                  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255, 255, 127, 0, 0, 1, 32, 141, 1,
                  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255, 255, 127, 0, 0, 1, 32,
                  141, 1, 2, 3, 4, 5, 6, 7, 8, 15, 47, 98, 115, 118, 95, 112, 50, 112, 58, 48, 46,
                  48, 46, 48, 47, 241, 251, 9, 0>>

  test "Command.name/1" do
    assert Command.name(%Version{}) == "version"
  end

  test "Command.get_payload/1" do
    version = %Version{
      version: 98_765,
      services: [:node_network],
      nonce: <<0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08>>,
      timestamp: ~U[2009-01-09 02:54:25Z],
      user_agent: "/bsv_p2p:0.0.0/",
      latest_block: 654_321,
      recipient: nil,
      sender: nil
    }

    assert @test_payload == Command.get_payload(version)
  end

  test "BsvP2p.Command.Version.from_payload/1" do
    assert %Version{
             version: 98_765,
             services: [:node_network],
             nonce: <<0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08>>,
             timestamp: ~U[2009-01-09 02:54:25Z],
             user_agent: "/bsv_p2p:0.0.0/",
             latest_block: 654_321,
             recipient: nil,
             sender: nil
           } == Version.from_payload(@test_payload)
  end

  test "BsvP2p.Command.Version.get_services_payload/1" do
    command = %Version{
      version: 98_765,
      services: [:node_network],
      nonce: <<0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08>>,
      timestamp: ~U[2009-01-09 02:54:25Z],
      user_agent: "/bsv_p2p:0.0.0/",
      latest_block: 654_321,
      recipient: nil,
      sender: nil
    }

    assert 1 == Version.get_services_payload(command)
    assert 2 == Version.get_services_payload(%{command | services: [:node_getutxo]})
    assert 4 == Version.get_services_payload(%{command | services: [:node_bloom]})
    assert 1024 == Version.get_services_payload(%{command | services: [:node_network_limited]})

    assert 1031 ==
             Version.get_services_payload(%{
               command
               | services: [:node_network, :node_getutxo, :node_bloom, :node_network_limited]
             })

    assert_raise FunctionClauseError, fn ->
      Version.get_services_payload(%{command | services: [:foo]})
    end
  end

  test "BsvP2p.Command.Version.services_from_payload/1" do
    assert [:node_network] == Version.services_from_payload(1)
    assert [:node_getutxo] == Version.services_from_payload(2)
    assert [:node_bloom] == Version.services_from_payload(4)
    assert [:node_network_limited] == Version.services_from_payload(1024)

    assert [:node_network, :node_getutxo, :node_bloom, :node_network_limited] ==
             Version.services_from_payload(1031)

    assert [:node_network, :node_getutxo, :node_bloom] == Version.services_from_payload(0xFF)
  end
end
