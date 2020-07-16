defmodule BsvP2p.Command.Version do
  @moduledoc """
  Bitcoin P2P "version" command.
  """
  alias BSV.Util
  alias BsvP2p.Util.Services

  @version Mix.Project.config()[:version]

  defstruct version: 70_015,
            services: [:node_network],
            nonce: BSV.Util.random_bytes(8),
            timestamp: DateTime.utc_now(),
            user_agent: "/bsv_p2p:#{@version}/",
            latest_block: 0,
            recipient: nil,
            # TODO determine automatically.
            sender: nil

  @type t :: %__MODULE__{
          version: non_neg_integer,
          services: [Services.t()],
          nonce: binary,
          timestamp: DateTime.t(),
          user_agent: String.t(),
          latest_block: non_neg_integer,
          # TODO
          recipient: map() | nil,
          # TODO
          sender: map() | nil
        }

  defimpl BsvP2p.Command, for: __MODULE__ do
    @spec name(BsvP2p.Command.Version.t()) :: String.t()
    def name(_), do: "version"

    @spec get_payload(BsvP2p.Command.Version.t()) :: binary
    def get_payload(%BsvP2p.Command.Version{} = command) do
      services_payload = Services.get_payload(command.services)

      <<command.version::integer-unsigned-size(32)-little>> <>
        <<services_payload::integer-unsigned-size(64)-little>> <>
        <<DateTime.to_unix(command.timestamp)::integer-unsigned-size(64)-little>> <>
        <<0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00>> <>
        <<0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0x7F, 0x00,
          0x00,
          0x01>> <>
        <<0x20, 0x8D>> <>
        <<0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00>> <>
        <<0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0x7F, 0x00,
          0x00,
          0x01>> <>
        <<0x20, 0x8D>> <>
        command.nonce <>
        Util.VarBin.serialize_bin(command.user_agent) <>
        <<command.latest_block::integer-unsigned-size(32)-little>>
    end
  end

  @spec from_payload(binary) :: BsvP2p.Command.Version.t()
  def from_payload(
        <<version::integer-unsigned-size(32)-little, services::integer-unsigned-size(64)-little,
          timestamp::integer-unsigned-size(64)-little, _recipient::binary-size(26),
          _sender::binary-size(26), nonce::binary-size(8), rest::binary>>
      ) do
    {user_agent, <<latest_block::integer-unsigned-size(32)-little>>} = Util.VarBin.parse_bin(rest)

    %__MODULE__{
      version: version,
      services: Services.from_payload(services),
      nonce: nonce,
      timestamp: DateTime.from_unix!(timestamp),
      recipient: nil,
      sender: nil,
      user_agent: user_agent,
      latest_block: latest_block
    }
  end
end
