defmodule BsvP2p.Command.Sendheaders do
  @moduledoc """
  Bitcoin P2P "sendheaders" command.
  """

  defstruct []
  @type t :: %__MODULE__{}

  defimpl BsvP2p.Command, for: __MODULE__ do
    @spec name(BsvP2p.Command.Sendheaders.t()) :: String.t()
    def name(_), do: "sendheaders"

    @spec get_payload(BsvP2p.Command.Sendheaders.t()) :: binary
    def get_payload(%BsvP2p.Command.Sendheaders{}), do: <<>>
  end

  @spec from_payload(binary) :: BsvP2p.Command.Sendheaders.t()
  def from_payload(<<>>), do: %__MODULE__{}
end
