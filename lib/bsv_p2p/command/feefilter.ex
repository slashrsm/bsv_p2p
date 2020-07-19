defmodule BsvP2p.Command.Feefilter do
  @moduledoc """
  Bitcoin P2P "feefilter" command.
  """

  defstruct [:fee]

  @type t :: %__MODULE__{fee: pos_integer}

  defimpl BsvP2p.Command, for: __MODULE__ do
    @spec name(BsvP2p.Command.Feefilter.t()) :: String.t()
    def name(_), do: "feefilter"

    @spec get_payload(BsvP2p.Command.Feefilter.t()) :: binary
    def get_payload(%BsvP2p.Command.Feefilter{fee: fee}), do: <<fee::integer-size(64)-little>>
  end

  @spec from_payload(binary) :: BsvP2p.Command.Feefilter.t()
  def from_payload(<<fee::integer-size(64)-little>>), do: %__MODULE__{fee: fee}
end
