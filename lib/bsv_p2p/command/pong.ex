defmodule BsvP2p.Command.Pong do
  @moduledoc """
  Bitcoin P2P "verack" command.
  """

  defstruct nonce: <<0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00>>

  @type t :: %__MODULE__{
          nonce: binary
        }

  defimpl BsvP2p.Command, for: __MODULE__ do
    @spec name(BsvP2p.Command.Pong.t()) :: String.t()
    def name(_), do: "pong"

    @spec get_payload(BsvP2p.Command.Pong.t()) :: binary
    def get_payload(%BsvP2p.Command.Pong{nonce: nonce}), do: nonce
  end

  @spec from_payload(binary) :: BsvP2p.Command.Pong.t()
  def from_payload(<<nonce::binary-size(8)>>), do: %__MODULE__{nonce: nonce}
end
