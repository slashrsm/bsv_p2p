defmodule BsvP2p.Command.Headers do
  @moduledoc """
  Bitcoin P2P "headers" command.
  """
  alias BSV.Util.VarBin
  alias BsvP2p.Block

  defstruct headers: []

  @type t :: %__MODULE__{headers: [Block.t()]}

  defimpl BsvP2p.Command, for: __MODULE__ do
    @spec name(BsvP2p.Command.Headers.t()) :: String.t()
    def name(_), do: "headers"

    @spec get_payload(BsvP2p.Command.Headers.t()) :: binary
    def get_payload(%BsvP2p.Command.Headers{headers: headers}) do
      (headers |> Enum.count() |> VarBin.serialize_int()) <>
        Enum.reduce(
          headers,
          <<>>,
          fn
            %Block{transactions: nil} = header, acc ->
              acc <>
                Block.to_binary(header) <>
                VarBin.serialize_int(0)

            header, acc ->
              acc <>
                Block.to_binary(header) <>
                (header.transactions |> Enum.count() |> VarBin.serialize_int())
          end
        )
    end
  end

  @spec from_payload(binary) :: __MODULE__.t()
  def from_payload(payload) do
    {_count, headers} = VarBin.parse_int(payload)

    %__MODULE__{
      headers: do_get_headers(headers, [])
    }
  end

  defp do_get_headers(<<>>, acc), do: Enum.reverse(acc)

  defp do_get_headers(<<header::binary-size(80), rest::binary>>, acc) do
    {_transaction_count, rest} = VarBin.parse_int(rest)
    do_get_headers(rest, [Block.create!(header) | acc])
  end
end
