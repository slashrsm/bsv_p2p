defmodule BsvP2p.Util.ServicesTest do
  use ExUnit.Case
  alias BsvP2p.Util.Services

  test "BsvP2p.Util.Services.get_payload/1" do
    assert <<1, 0, 0, 0, 0, 0, 0, 0>> == Services.get_payload([:node_network])
    assert <<2, 0, 0, 0, 0, 0, 0, 0>> == Services.get_payload([:node_getutxo])
    assert <<4, 0, 0, 0, 0, 0, 0, 0>> == Services.get_payload([:node_bloom])
    assert <<0, 4, 0, 0, 0, 0, 0, 0>> == Services.get_payload([:node_network_limited])

    assert <<7, 4, 0, 0, 0, 0, 0, 0>> ==
             Services.get_payload([
               :node_network,
               :node_getutxo,
               :node_bloom,
               :node_network_limited
             ])

    assert_raise FunctionClauseError, fn ->
      Services.get_payload([:foo])
    end
  end

  test "BsvP2p.Util.Services.from_payload/1" do
    assert [:node_network] == Services.from_payload(<<1, 0, 0, 0, 0, 0, 0, 0>>)
    assert [:node_getutxo] == Services.from_payload(<<2, 0, 0, 0, 0, 0, 0, 0>>)
    assert [:node_bloom] == Services.from_payload(<<4, 0, 0, 0, 0, 0, 0, 0>>)
    assert [:node_network_limited] == Services.from_payload(<<0, 4, 0, 0, 0, 0, 0, 0>>)

    assert [:node_network, :node_getutxo, :node_bloom, :node_network_limited] ==
             Services.from_payload(<<7, 4, 0, 0, 0, 0, 0, 0>>)

    assert [:node_network, :node_getutxo, :node_bloom] ==
             Services.from_payload(<<0xFF, 0, 0, 0, 0, 0, 0, 0>>)
  end
end
