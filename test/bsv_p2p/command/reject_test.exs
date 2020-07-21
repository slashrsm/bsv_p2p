defmodule BsvP2p.Command.RejectTest do
  use ExUnit.Case
  alias BsvP2p.Command
  alias BsvP2p.Command.Reject
  doctest BsvP2p.Command.Reject

  @test_cases %{
    "\x04dustA\fDust outputs" => %Reject{type: "dust", code: :dust, reason: "Dust outputs"},
    "\tmalformed\x01\tmalformed\xFF\xEE\xDD\xCC" => %Reject{
      type: "malformed",
      code: :malformed,
      reason: "malformed",
      data: <<0xFF, 0xEE, 0xDD, 0xCC>>
    },
    "\x03foo\x10\x03bar" => %Reject{type: "foo", code: :invalid, reason: "bar"},
    "\x03foo\x11\x03bar" => %Reject{type: "foo", code: :obsolete, reason: "bar"},
    "\x03foo\x12\x03bar" => %Reject{type: "foo", code: :duplicate, reason: "bar"},
    "\x03foo\x40\x03bar" => %Reject{type: "foo", code: :nonstandard, reason: "bar"},
    "\x03foo\x42\x03bar" => %Reject{type: "foo", code: :insufficient_fee, reason: "bar"},
    "\x03foo\x43\x03bar" => %Reject{type: "foo", code: :checkpoint, reason: "bar"}
  }

  test "Command.name/1" do
    assert Command.name(%Reject{type: "dust", code: :dust, reason: "Dust outputs"}) == "reject"
  end

  test "Command.get_payload/1" do
    Enum.each(@test_cases, fn {payload, cmd} ->
      assert payload == Command.get_payload(cmd)
    end)
  end

  test "Command.get_payload/1 fails with invalid code" do
    assert_raise FunctionClauseError, fn ->
      Command.get_payload(%Reject{type: "foo", code: :foo, reason: "bar"})
    end
  end

  test "BsvP2p.Command.Reject.from_payload/1" do
    Enum.each(@test_cases, fn {payload, cmd} ->
      assert Reject.from_payload(payload) == cmd
    end)
  end
end
