defmodule BsvP2p.Util.NetworkAddressTest do
  use ExUnit.Case
  alias BsvP2p.Util.NetworkAddress
  import Mock

  test "BsvP2p.Util.NetworkAddress.get_payload/1" do
    assert "\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xFF\xFF\d\0\0\x01 \x8D" ==
             NetworkAddress.get_payload(
               %NetworkAddress{
                 ip: "127.0.0.1",
                 port: 8333,
                 timestamp: ~U[2009-01-09 02:54:25Z],
                 services: [:node_network]
               },
               false
             )

    assert "a\xBCfI\0\0\0\0\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xFF\xFF\d\0\0\x01 \x8D" ==
             NetworkAddress.get_payload(
               %NetworkAddress{
                 ip: "127.0.0.1",
                 port: 8333,
                 timestamp: ~U[2009-01-09 02:54:25Z],
                 services: [:node_network]
               },
               true
             )

    assert "\x03\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xFF\xFF\n\0\0\x01\x1F\x90" ==
             NetworkAddress.get_payload(
               %NetworkAddress{
                 ip: "10.0.0.1",
                 port: 8080,
                 timestamp: ~U[2009-01-09 02:54:25Z],
                 services: [:node_network, :node_getutxo]
               },
               false
             )

    assert "a\xBCfI\0\0\0\0\x03\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xFF\xFF\n\0\0\x01\x1F\x90" ==
             NetworkAddress.get_payload(
               %NetworkAddress{
                 ip: "10.0.0.1",
                 port: 8080,
                 timestamp: ~U[2009-01-09 02:54:25Z],
                 services: [:node_network, :node_getutxo]
               },
               true
             )

    assert "\x03\0\0\0\0\0\0\0 \x01\r\xB8\x85\xA3\0\0\0\0\x8A.\x03ps4\x1F\x90" ==
             NetworkAddress.get_payload(
               %NetworkAddress{
                 ip: "2001:0db8:85a3:0000:0000:8a2e:0370:7334",
                 port: 8080,
                 timestamp: ~U[2009-01-09 02:54:25Z],
                 services: [:node_network, :node_getutxo]
               },
               false
             )

    assert "a\xBCfI\0\0\0\0\x03\0\0\0\0\0\0\0 \x01\r\xB8\x85\xA3\0\0\0\0\x8A.\x03ps4\x1F\x90" ==
             NetworkAddress.get_payload(
               %NetworkAddress{
                 ip: "2001:0db8:85a3:0000:0000:8a2e:0370:7334",
                 port: 8080,
                 timestamp: ~U[2009-01-09 02:54:25Z],
                 services: [:node_network, :node_getutxo]
               },
               true
             )
  end

  test "BsvP2p.Util.NetworkAddress.from_payload/1 with timestamp" do
    assert %NetworkAddress{
             ip: "127.0.0.1",
             port: 8333,
             timestamp: ~U[2009-01-09 02:54:25Z],
             services: [:node_network]
           } ==
             NetworkAddress.from_payload(
               "a\xBCfI\0\0\0\0\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xFF\xFF\d\0\0\x01 \x8D"
             )

    assert %NetworkAddress{
             ip: "10.0.0.1",
             port: 8080,
             timestamp: ~U[2009-01-09 02:54:25Z],
             services: [:node_network, :node_getutxo]
           } ==
             NetworkAddress.from_payload(
               "a\xBCfI\0\0\0\0\x03\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xFF\xFF\n\0\0\x01\x1F\x90"
             )

    assert %NetworkAddress{
             ip: "2001:db8:85a3::8a2e:370:7334",
             port: 8080,
             timestamp: ~U[2009-01-09 02:54:25Z],
             services: [:node_network, :node_getutxo]
           } ==
             NetworkAddress.from_payload(
               "a\xBCfI\0\0\0\0\x03\0\0\0\0\0\0\0 \x01\r\xB8\x85\xA3\0\0\0\0\x8A.\x03ps4\x1F\x90"
             )
  end

  test "BsvP2p.Util.NetworkAddress.from_payload/1 without timestamp" do
    assert %NetworkAddress{
             ip: "127.0.0.1",
             port: 8333,
             timestamp: ~U[2009-01-09 02:54:25Z],
             services: [:node_network]
           } ==
             NetworkAddress.from_payload(
               "\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xFF\xFF\d\0\0\x01 \x8D",
               ~U[2009-01-09 02:54:25Z]
             )

    assert %NetworkAddress{
             ip: "10.0.0.1",
             port: 8080,
             timestamp: ~U[2009-01-09 02:54:25Z],
             services: [:node_network, :node_getutxo]
           } ==
             NetworkAddress.from_payload(
               "\x03\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xFF\xFF\n\0\0\x01\x1F\x90",
               ~U[2009-01-09 02:54:25Z]
             )

    assert %NetworkAddress{
             ip: "2001:db8:85a3::8a2e:370:7334",
             port: 8080,
             timestamp: ~U[2009-01-09 02:54:25Z],
             services: [:node_network, :node_getutxo]
           } ==
             NetworkAddress.from_payload(
               "\x03\0\0\0\0\0\0\0 \x01\r\xB8\x85\xA3\0\0\0\0\x8A.\x03ps4\x1F\x90",
               ~U[2009-01-09 02:54:25Z]
             )
  end

  test "BsvP2p.Util.NetworkAddress.from_payload/1 without timestamp, with default time" do
    with_mock DateTime, utc_now: fn -> ~U[2009-01-09 02:54:25Z] end do
      assert %NetworkAddress{
               ip: "127.0.0.1",
               port: 8333,
               timestamp: ~U[2009-01-09 02:54:25Z],
               services: [:node_network]
             } ==
               NetworkAddress.from_payload(
                 "\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xFF\xFF\d\0\0\x01 \x8D"
               )

      assert %NetworkAddress{
               ip: "10.0.0.1",
               port: 8080,
               timestamp: ~U[2009-01-09 02:54:25Z],
               services: [:node_network, :node_getutxo]
             } ==
               NetworkAddress.from_payload(
                 "\x03\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xFF\xFF\n\0\0\x01\x1F\x90"
               )

      assert %NetworkAddress{
               ip: "2001:db8:85a3::8a2e:370:7334",
               port: 8080,
               timestamp: ~U[2009-01-09 02:54:25Z],
               services: [:node_network, :node_getutxo]
             } ==
               NetworkAddress.from_payload(
                 "\x03\0\0\0\0\0\0\0 \x01\r\xB8\x85\xA3\0\0\0\0\x8A.\x03ps4\x1F\x90"
               )
    end
  end
end
