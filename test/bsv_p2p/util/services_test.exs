defmodule BsvP2p.Util.ServicesTest do
  use ExUnit.Case
  alias BsvP2p.Util.Services

  test "BsvP2p.Util.Services.get_payload/1" do
    assert 1 == Services.get_payload([:node_network])
    assert 2 == Services.get_payload([:node_getutxo])
    assert 4 == Services.get_payload([:node_bloom])
    assert 1024 == Services.get_payload([:node_network_limited])

    assert 1031 ==
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
    assert [:node_network] == Services.from_payload(1)
    assert [:node_getutxo] == Services.from_payload(2)
    assert [:node_bloom] == Services.from_payload(4)
    assert [:node_network_limited] == Services.from_payload(1024)

    assert [:node_network, :node_getutxo, :node_bloom, :node_network_limited] ==
             Services.from_payload(1031)

    assert [:node_network, :node_getutxo, :node_bloom] == Services.from_payload(0xFF)
  end
end
