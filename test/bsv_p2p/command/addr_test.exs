defmodule BsvP2p.Command.AddrTest do
  use ExUnit.Case
  alias BsvP2p.Command
  alias BsvP2p.Command.Addr
  alias BsvP2p.Util.NetworkAddress
  doctest BsvP2p.Command.Addr

  test "Command.name/1" do
    assert Command.name(%Addr{}) == "addr"
  end

  test "Command.get_payload/1" do
    assert "\x02a\xBCfI\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xFF\xFF\d\0\0\x01 \x8Da\xBCfI\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xFF\xFF\d\0\0\x01 \x8D" ==
             Command.get_payload(%Addr{
               addresses: [
                 %NetworkAddress{timestamp: ~U[2009-01-09 02:54:25Z]},
                 %NetworkAddress{timestamp: ~U[2009-01-09 02:54:25Z]}
               ]
             })
  end

  test "BsvP2p.Command.Getaddr.from_payload/1" do
    assert Addr.from_payload(
             "\x02a\xBCfI\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xFF\xFF\d\0\0\x01 \x8Da\xBCfI\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\xFF\xFF\d\0\0\x01 \x8D"
           ) == %Addr{
             addresses: [
               %NetworkAddress{timestamp: ~U[2009-01-09 02:54:25Z]},
               %NetworkAddress{timestamp: ~U[2009-01-09 02:54:25Z]}
             ]
           }
  end
end
