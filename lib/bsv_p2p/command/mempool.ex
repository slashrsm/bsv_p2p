defmodule BsvP2p.Command.Mempool do
  @moduledoc """
  Bitcoin P2P "mempool" command.
  """

  defstruct []
  @type t :: %__MODULE__{}

  defimpl BsvP2p.Command, for: __MODULE__ do
    @spec name(BsvP2p.Command.Mempool.t()) :: String.t()
    def name(_), do: "mempool"

    @spec get_payload(BsvP2p.Command.Mempool.t()) :: binary
    def get_payload(%BsvP2p.Command.Mempool{}), do: <<>>
  end

  @spec from_payload(binary) :: __MODULE__.t()
  def from_payload(<<>>), do: %__MODULE__{}
end
