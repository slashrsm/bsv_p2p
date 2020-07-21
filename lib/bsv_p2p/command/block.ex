defmodule BsvP2p.Command.Block do
  @moduledoc """
  Bitcoin P2P "block" command.
  """
  alias BSV.Block

  @enforce_keys [:block]

  defstruct [:block]

  @type t :: %__MODULE__{block: Block.t()}

  defimpl BsvP2p.Command, for: __MODULE__ do
    @spec name(BsvP2p.Command.Block.t()) :: String.t()
    def name(_), do: "block"

    @spec get_payload(BsvP2p.Command.Block.t()) :: binary
    def get_payload(%BsvP2p.Command.Block{block: block}),
      do: Block.serialize(block, true)
  end

  @spec from_payload(binary) :: __MODULE__.t()
  def from_payload(payload) do
    {block, ""} = Block.parse(payload, true)

    %__MODULE__{
      block: block
    }
  end
end
