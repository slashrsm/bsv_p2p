defmodule BsvP2p.Command.Unknown do
  @moduledoc """
  Represents unknown incomming command.
  """

  defstruct [:name, :payload]

  @type t :: %__MODULE__{
          name: String.t(),
          payload: binary()
        }

  defimpl BsvP2p.Command, for: __MODULE__ do
    @spec name(BsvP2p.Command.Unknown.t()) :: String.t()
    def name(_), do: "_unknown"

    @spec get_payload(BsvP2p.Command.Unknown.t()) :: binary
    def get_payload(%BsvP2p.Command.Unknown{}), do: <<>>
  end

  @spec from_payload(binary) :: BsvP2p.Command.Unknown.t()
  def from_payload(_), do: %__MODULE__{name: "", payload: <<>>}
end
