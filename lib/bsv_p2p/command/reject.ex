defmodule BsvP2p.Command.Reject do
  @moduledoc """
  Bitcoin P2P "reject" command.
  """
  alias BSV.Util.VarBin

  @enforce_keys [:type, :code, :reason]
  defstruct type: nil, code: nil, reason: nil, data: <<>>

  @type_codes %{
    0x01 => :malformed,
    0x10 => :invalid,
    0x11 => :obsolete,
    0x12 => :duplicate,
    0x40 => :nonstandard,
    0x41 => :dust,
    0x42 => :insufficient_fee,
    0x43 => :checkpoint
  }

  @type type_code ::
          :malformed
          | :invalid
          | :obsolete
          | :duplicate
          | :nonstandard
          | :dust
          | :insufficient_fee
          | :checkpoint

  @type t :: %__MODULE__{
          type: String.t(),
          code: type_code,
          reason: String.t(),
          data: binary
        }

  defimpl BsvP2p.Command, for: __MODULE__ do
    @spec name(BsvP2p.Command.Reject.t()) :: String.t()
    def name(_), do: "reject"

    @spec get_payload(BsvP2p.Command.Reject.t()) :: binary
    def get_payload(%BsvP2p.Command.Reject{} = command) do
      VarBin.serialize_bin(command.type) <>
        <<get_code(command.code)::integer-size(8)>> <>
        VarBin.serialize_bin(command.reason) <>
        command.data
    end

    @spec get_code(BsvP2p.Command.Reject.type_code()) :: pos_integer
    for {code, type} <- Module.get_attribute(BsvP2p.Command.Reject, :type_codes) do
      defp get_code(unquote(type)), do: unquote(code)
    end
  end

  @spec from_payload(binary) :: __MODULE__.t()
  def from_payload(payload) do
    {type, <<code::integer-size(8), rest::binary>>} = VarBin.parse_bin(payload)
    {reason, data} = VarBin.parse_bin(rest)

    %__MODULE__{
      type: type,
      code: @type_codes[code],
      reason: reason,
      data: data
    }
  end
end
