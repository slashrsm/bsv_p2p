defmodule BsvP2p.Util.MessageTest do
  use ExUnit.Case
  alias BsvP2p.Command
  alias BsvP2p.Message
  import Mock

  @version_payload <<227, 225, 243, 232, 118, 101, 114, 115, 105, 111, 110, 0, 0, 0, 0, 0, 101, 0,
                     0, 0, 182, 72, 90, 132, 205, 129, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 97, 188, 102,
                     73, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255,
                     255, 127, 0, 0, 1, 32, 141, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 255, 255, 127, 0, 0, 1, 32, 141, 1, 2, 3, 4, 5, 6, 7, 8, 15, 47, 98,
                     115, 118, 95, 112, 50, 112, 58, 48, 46, 48, 46, 48, 47, 241, 251, 9, 0, 1>>

  @verack_payload <<244, 229, 243, 244, 118, 101, 114, 97, 99, 107, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    93, 246, 224, 226>>

  @ping_payload <<227, 225, 243, 232, 112, 105, 110, 103, 0, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 37,
                  2, 250, 148, 1, 2, 3, 4, 5, 6, 7, 8>>

  @pong_payload <<227, 225, 243, 232, 112, 111, 110, 103, 0, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 37,
                  2, 250, 148, 1, 2, 3, 4, 5, 6, 7, 8>>

  @version_command %Command.Version{
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
  }

  test "Message.parse/1 with single payload" do
    with_mock DateTime,
      utc_now: fn -> ~U[2009-01-09 02:54:25Z] end,
      from_unix!: fn 1_231_469_665 -> ~U[2009-01-09 02:54:25Z] end do
      assert {[{:ok, :main, @version_command}], ""} == Message.parse(@version_payload)
      assert {[{:ok, :test, %Command.Verack{}}], ""} == Message.parse(@verack_payload)
    end
  end

  test "Message.parse/1 with extra data" do
    with_mock DateTime,
      utc_now: fn -> ~U[2009-01-09 02:54:25Z] end,
      from_unix!: fn 1_231_469_665 -> ~U[2009-01-09 02:54:25Z] end do
      assert {[{:ok, :main, @version_command}], <<0xFF, 0xEE, 0xDD, 0xCC>>} ==
               Message.parse(@version_payload <> <<0xFF, 0xEE, 0xDD, 0xCC>>)
    end
  end

  test "Message.parse/1 with multiple payloads" do
    with_mock DateTime,
      utc_now: fn -> ~U[2009-01-09 02:54:25Z] end,
      from_unix!: fn 1_231_469_665 -> ~U[2009-01-09 02:54:25Z] end do
      assert {[
                {:ok, :main,
                 %Command.Ping{nonce: <<0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08>>}},
                {:ok, :main,
                 %Command.Pong{nonce: <<0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08>>}}
              ], ""} == Message.parse(@ping_payload <> @pong_payload)
    end
  end

  test "Message.parse/1 errors with invalid checksum" do
    assert {[
              {:error, "Invalid checksum for 'verack': \xFF\xFF\xFF\xFF - ."}
            ],
            ""} ==
             Message.parse(
               <<244, 229, 243, 244, 118, 101, 114, 97, 99, 107, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                 255, 255, 255, 255>>
             )
  end

  test "Message.parse/1 errors with invalid payload" do
    assert {[
              {:error, "Invalid command: \0\0\0\0, verack, ]\xF6\xE0\xE2, ."}
            ],
            ""} ==
             Message.parse(
               <<0, 0, 0, 0, 118, 101, 114, 97, 99, 107, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 93, 246,
                 224, 226>>
             )
  end

  test "Message.parse/2 for unknown command" do
    assert {[{:ok, :test, %Command.Unknown{name: "foo", payload: <<>>}}], ""} ==
             Message.parse(
               <<244, 229, 243, 244, "foo", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 93, 246, 224,
                 226>>
             )
  end

  test "Message.create_payload/1" do
    assert @version_payload == Message.create_payload(@version_command, :main)
  end
end
