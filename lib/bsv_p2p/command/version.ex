defmodule BsvP2p.Command.Version do
  @moduledoc """
  Bitcoin P2P "version" command.
  """
  alias BSV.Util
  alias BsvP2p.Util.NetworkAddress
  alias BsvP2p.Util.Services
  require Logger

  @version Mix.Project.config()[:version]

  defstruct version: 70_015,
            services: [:node_network],
            nonce: BSV.Util.random_bytes(8),
            timestamp: DateTime.utc_now(),
            user_agent: "/bsv_p2p:#{@version}/",
            latest_block: 0,
            recipient: %NetworkAddress{},
            sender: %NetworkAddress{},
            relay: true

  @type t :: %__MODULE__{
          version: non_neg_integer,
          services: [Services.t()],
          nonce: binary,
          timestamp: DateTime.t(),
          user_agent: String.t(),
          latest_block: non_neg_integer,
          recipient: NetworkAddress.t(),
          sender: NetworkAddress.t(),
          relay: boolean
        }

  defimpl BsvP2p.Command, for: __MODULE__ do
    @spec name(BsvP2p.Command.Version.t()) :: String.t()
    def name(_), do: "version"

    @spec get_payload(BsvP2p.Command.Version.t()) :: binary
    def get_payload(%BsvP2p.Command.Version{} = command) do
      <<command.version::integer-unsigned-size(32)-little>> <>
        Services.get_payload(command.services) <>
        <<DateTime.to_unix(command.timestamp)::integer-unsigned-size(64)-little>> <>
        NetworkAddress.get_payload(command.recipient, false) <>
        NetworkAddress.get_payload(command.sender, false) <>
        command.nonce <>
        Util.VarBin.serialize_bin(command.user_agent) <>
        <<command.latest_block::integer-unsigned-size(32)-little>> <>
        <<if(command.relay, do: 0x01, else: 0x00)>>
    end
  end

  @spec from_payload(binary) :: BsvP2p.Command.Version.t()
  def from_payload(
        <<version::integer-unsigned-size(32)-little, services::binary-size(8),
          timestamp::integer-unsigned-size(64)-little, recipient::binary-size(26),
          sender::binary-size(26), nonce::binary-size(8), rest::binary>>
      ) do
    {user_agent,
     <<latest_block::integer-unsigned-size(32)-little, relay::integer-unsigned-size(8)>>} =
      Util.VarBin.parse_bin(rest)

    %__MODULE__{
      version: version,
      services: Services.from_payload(services),
      nonce: nonce,
      timestamp: DateTime.from_unix!(timestamp),
      recipient: NetworkAddress.from_payload(recipient),
      sender: NetworkAddress.from_payload(sender),
      user_agent: user_agent,
      latest_block: latest_block,
      relay: relay > 0
    }
  end
end
