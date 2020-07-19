defmodule BsvP2p.Command.Tx do
  @moduledoc """
  Bitcoin P2P "tx" command.
  """
  alias BSV.Transaction

  @enforce_keys [:transaction]

  defstruct [:transaction]

  @type t :: %__MODULE__{transaction: Transaction.t()}

  defimpl BsvP2p.Command, for: __MODULE__ do
    @spec name(BsvP2p.Command.Tx.t()) :: String.t()
    def name(_), do: "tx"

    @spec get_payload(BsvP2p.Command.Tx.t()) :: binary
    def get_payload(%BsvP2p.Command.Tx{transaction: transaction}),
      do: Transaction.serialize(transaction)
  end

  @spec from_payload(binary) :: __MODULE__.t()
  def from_payload(payload) do
    {tx, ""} = Transaction.parse(payload)

    %__MODULE__{
      transaction: tx
    }
  end
end
