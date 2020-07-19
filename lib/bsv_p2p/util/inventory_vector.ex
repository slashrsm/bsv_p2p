defmodule BsvP2p.Util.InventoryVector do
  @moduledoc """
  Handles inventory vectors.
  """
  use Bitwise

  @vector_types %{
    0x00 => :error,
    0x01 => :transaction,
    0x02 => :block,
    0x03 => :filtered_block,
    0x04 => :compact_block
  }

  @enforce_keys [:type, :hash]

  defstruct [:type, :hash]

  @type t :: %__MODULE__{
          type: :error | :transaction | :block | :filtered_block | :compact_block,
          hash: <<_::256>>
        }

  @spec get_payload(__MODULE__.t()) :: binary()
  def get_payload(%__MODULE__{type: type, hash: hash}) do
    type_id = Enum.find_index(@vector_types, fn {_, value} -> value == type end)
    <<type_id::integer-unsigned-size(32)-little>> <> hash
  end

  @spec from_payload(binary()) :: __MODULE__.t()
  def from_payload(<<type::integer-unsigned-size(32)-little, hash::binary-size(32)>>) do
    %__MODULE__{
      type: @vector_types[type],
      hash: hash
    }
  end
end
