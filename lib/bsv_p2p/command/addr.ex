defmodule BsvP2p.Command.Addr do
  @moduledoc """
  Bitcoin P2P "addr" command.
  """
  alias BSV.Util.VarBin
  alias BsvP2p.Util.NetworkAddress

  defstruct addresses: []

  @type t :: %__MODULE__{
          addresses: [NetworkAddress.t()]
        }

  defimpl BsvP2p.Command, for: __MODULE__ do
    @spec name(BsvP2p.Command.Addr.t()) :: String.t()
    def name(_), do: "addr"

    @spec get_payload(BsvP2p.Command.Addr.t()) :: binary
    def get_payload(%BsvP2p.Command.Addr{addresses: addresses}) do
      (addresses |> Enum.count() |> VarBin.serialize_int()) <>
        Enum.reduce(
          addresses,
          <<>>,
          fn address, acc ->
            acc <> NetworkAddress.get_payload(address, true)
          end
        )
    end
  end

  @spec from_payload(binary) :: BsvP2p.Command.Addr.t()
  def from_payload(payload) do
    {_addr_count, payload} = VarBin.parse_int(payload)

    %__MODULE__{
      addresses: parse_addresses(payload, [])
    }
  end

  @spec parse_addresses(binary, [NetworkAddress.t()]) :: [NetworkAddress.t()]
  defp parse_addresses(<<>>, addresses), do: Enum.reverse(addresses)

  defp parse_addresses(<<raw_address::binary-size(30), rest::binary>>, addresses) do
    parse_addresses(rest, [NetworkAddress.from_payload(raw_address) | addresses])
  end
end
