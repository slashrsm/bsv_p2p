defmodule BsvP2p.Util.Services do
  @moduledoc """
  Handles node service flags.
  """
  use Bitwise

  @service_bits %{
    0x01 => :node_network,
    0x02 => :node_getutxo,
    0x04 => :node_bloom,
    0x400 => :node_network_limited
  }

  @type t :: :node_network | :node_getutxo | :node_bloom | :node_network_limited

  @spec get_payload([__MODULE__.t()]) :: binary()
  def get_payload(services) do
    <<do_payload(services, 0)::integer-unsigned-size(64)-little>>
  end

  @spec do_payload([__MODULE__.t()], non_neg_integer) :: non_neg_integer
  defp do_payload([:node_network | other_services], payload),
    do: do_payload(other_services, payload ||| 1)

  defp do_payload([:node_getutxo | other_services], payload),
    do: do_payload(other_services, payload ||| 2)

  defp do_payload([:node_bloom | other_services], payload),
    do: do_payload(other_services, payload ||| 4)

  defp do_payload([:node_network_limited | other_services], payload),
    do: do_payload(other_services, payload ||| 1024)

  defp do_payload([], payload), do: payload

  @spec from_payload(binary()) :: [__MODULE__.t()]
  def from_payload(<<payload::integer-unsigned-size(64)-little>>) do
    @service_bits
    |> Enum.map(fn {bits, service} -> {bits &&& payload, service} end)
    |> Enum.filter(fn {present, _service} -> present > 0 end)
    |> Enum.map(fn {_, service} -> service end)
  end
end
