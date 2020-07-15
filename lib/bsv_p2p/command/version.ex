defmodule BsvP2p.Command.Version do
  @moduledoc """
  Bitcoin P2P "version" command.
  """
  alias BSV.Util
  use Bitwise

  @version Mix.Project.config()[:version]
  @service_bits %{
    0x01 => :node_network,
    0x02 => :node_getutxo,
    0x04 => :node_bloom,
    0x400 => :node_network_limited
  }

  defstruct version: 70_015,
            services: [:node_network],
            nonce: BSV.Util.random_bytes(8),
            timestamp: DateTime.utc_now(),
            user_agent: "/bsv_p2p:#{@version}/",
            latest_block: 0,
            recipient: nil,
            # TODO determine automatically.
            sender: nil

  @type node_service :: :node_netowrk | :node_getutxo | :node_bloom | :node_network_limited

  @type t :: %__MODULE__{
          version: non_neg_integer,
          services: [node_service],
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
      services_payload = BsvP2p.Command.Version.get_services_payload(command)

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
      services: services_from_payload(services),
      nonce: nonce,
      timestamp: DateTime.from_unix!(timestamp),
      recipient: nil,
      sender: nil,
      user_agent: user_agent,
      latest_block: latest_block
    }
  end

  @spec get_services_payload(__MODULE__.t()) :: non_neg_integer
  def get_services_payload(%BsvP2p.Command.Version{services: services}) do
    do_services_payload(services, 0)
  end

  @spec do_services_payload([node_service], non_neg_integer) :: non_neg_integer
  defp do_services_payload([:node_network | other_services], payload),
    do: do_services_payload(other_services, payload ||| 1)

  defp do_services_payload([:node_getutxo | other_services], payload),
    do: do_services_payload(other_services, payload ||| 2)

  defp do_services_payload([:node_bloom | other_services], payload),
    do: do_services_payload(other_services, payload ||| 4)

  defp do_services_payload([:node_network_limited | other_services], payload),
    do: do_services_payload(other_services, payload ||| 1024)

  defp do_services_payload([], payload), do: payload

  @spec services_from_payload(non_neg_integer) :: [node_service]
  def services_from_payload(payload) do
    @service_bits
    |> Enum.map(fn {bits, service} -> {bits &&& payload, service} end)
    |> Enum.filter(fn {present, _service} -> present > 0 end)
    |> Enum.map(fn {_, service} -> service end)
  end
end
