defmodule BsvP2p.Command.Getaddr do
  @moduledoc """
  Bitcoin P2P "getaddr" command.
  """

  defstruct []
  @type t :: %__MODULE__{}

  defimpl BsvP2p.Command, for: __MODULE__ do
    @spec name(BsvP2p.Command.Getaddr.t()) :: String.t()
    def name(_), do: "getaddr"

    @spec get_payload(BsvP2p.Command.Getaddr.t()) :: binary
    def get_payload(%BsvP2p.Command.Getaddr{}), do: <<>>
  end

  @spec from_payload(binary) :: BsvP2p.Command.Getaddr.t()
  def from_payload(<<>>), do: %__MODULE__{}
end
