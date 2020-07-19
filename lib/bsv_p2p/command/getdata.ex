defmodule BsvP2p.Command.Getdata do
  @moduledoc """
  Bitcoin P2P "getdata" command.
  """
  alias BSV.Util.VarBin
  alias BsvP2p.Util.InventoryVector

  defstruct vectors: []

  @type t :: %__MODULE__{vectors: [InventoryVector.t()]}

  defimpl BsvP2p.Command, for: __MODULE__ do
    @spec name(BsvP2p.Command.Getdata.t()) :: String.t()
    def name(_), do: "getdata"

    @spec get_payload(BsvP2p.Command.Getdata.t()) :: binary
    def get_payload(%BsvP2p.Command.Getdata{vectors: vectors}) do
      (vectors |> Enum.count() |> VarBin.serialize_int()) <>
        Enum.reduce(
          vectors,
          <<>>,
          fn vector, acc -> acc <> InventoryVector.get_payload(vector) end
        )
    end
  end

  @spec from_payload(binary) :: __MODULE__.t()
  def from_payload(payload) do
    {_count, vectors} = VarBin.parse_int(payload)

    %__MODULE__{
      vectors: do_get_vectors(vectors, [])
    }
  end

  @spec do_get_vectors(binary, [InventoryVector.t()]) :: [InventoryVector.t()]
  defp do_get_vectors(<<>>, acc), do: Enum.reverse(acc)

  defp do_get_vectors(<<vector::binary-size(36), rest::binary>>, acc) do
    do_get_vectors(rest, [InventoryVector.from_payload(vector) | acc])
  end
end
