defmodule BsvP2p.Command.Protoconf do
  @moduledoc """
  Bitcoin P2P "protoconf" command.
  """
  alias BSV.Util.VarBin

  defstruct max_recv_payload_length: 2 * 1024 * 1024

  @type t :: %__MODULE__{
          max_recv_payload_length: non_neg_integer()
        }

  defimpl BsvP2p.Command, for: __MODULE__ do
    @spec name(BsvP2p.Command.Protoconf.t()) :: String.t()
    def name(_), do: "protoconf"

    @spec get_payload(BsvP2p.Command.Protoconf.t()) :: binary
    def get_payload(%BsvP2p.Command.Protoconf{max_recv_payload_length: max_length}) do
      # One field for now. If/when the command is extended we will need to make this dynamic.
      VarBin.serialize_int(1) <>
        <<max_length::integer-size(32)-unsigned-little>>
    end
  end

  @spec from_payload(binary) :: BsvP2p.Command.Protoconf.t()
  def from_payload(<<0x01, max_length::integer-size(32)-unsigned-little>>),
    do: %__MODULE__{max_recv_payload_length: max_length}
end
