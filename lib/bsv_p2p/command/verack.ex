defmodule BsvP2p.Command.Verack do
  @moduledoc """
  Bitcoin P2P "verack" command.
  """

  defstruct []
  @type t :: %__MODULE__{}

  defimpl BsvP2p.Command, for: __MODULE__ do
    @spec name(BsvP2p.Command.Verack.t()) :: String.t()
    def name(_), do: "verack"

    @spec get_payload(BsvP2p.Command.Verack.t()) :: binary
    def get_payload(%BsvP2p.Command.Verack{}), do: <<>>
  end

  @spec from_payload(binary) :: BsvP2p.Command.Verack.t()
  def from_payload(<<>>), do: %__MODULE__{}
end
