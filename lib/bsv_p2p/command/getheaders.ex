defmodule BsvP2p.Command.Getheaders do
  @moduledoc """
  Bitcoin P2P "getheaders" command.
  """
  alias BSV.Util.VarBin

  defstruct version: 70_015,
            # Genesis block.
            locator_hashes: [
              Base.decode16!("000000000019D6689C085AE165831E934FF763AE46A2A6C172B3F1B60A8CE26F")
            ],
            stop: <<0::integer-size(256)-little>>

  @type t :: %__MODULE__{
          version: non_neg_integer,
          locator_hashes: [<<_::256>>],
          stop: <<_::256>>
        }

  defimpl BsvP2p.Command, for: __MODULE__ do
    @spec name(BsvP2p.Command.Getheaders.t()) :: String.t()
    def name(_), do: "getheaders"

    @spec get_payload(BsvP2p.Command.Getheaders.t()) :: binary
    def get_payload(%BsvP2p.Command.Getheaders{
          version: version,
          locator_hashes: locators,
          stop: stop
        }) do
      <<version::integer-unsigned-size(32)-little>> <>
        (locators |> Enum.count() |> VarBin.serialize_int()) <>
        Enum.reduce(locators, <<>>, fn hash, acc -> hash <> acc end) <>
        stop
    end
  end

  @spec from_payload(binary) :: BsvP2p.Command.Getheaders.t()
  def from_payload(<<version::integer-unsigned-size(32)-little, rest::binary>>) do
    {count, rest} = VarBin.parse_int(rest)
    locators_byte_size = 32 * count
    <<locators::binary-size(locators_byte_size), stop::binary-size(32)>> = rest

    %__MODULE__{
      version: version,
      locator_hashes: split_locators(locators, []),
      stop: stop
    }
  end

  @spec set_stop_hash(__MODULE__.t(), String.t() | 0) :: __MODULE__.t()
  def set_stop_hash(command, 0), do: %{command | stop: <<0::integer-size(256)-little>>}
  def set_stop_hash(command, hash), do: %{command | stop: Base.decode16!(hash, case: :mixed)}

  # TODO Add sparse stuff.
  @spec set_locator_hashes(__MODULE__.t(), String.t() | [String.t()]) :: __MODULE__.t()
  def set_locator_hashes(command, hashes) when is_list(hashes) do
    %{command | locator_hashes: Enum.map(hashes, &Base.decode16!(&1, case: :mixed))}
  end

  def set_locator_hashes(command, hash), do: set_locator_hashes(command, [hash])

  @spec split_locators(binary, [binary]) :: [binary]
  defp split_locators(<<locator::binary-size(32), rest::binary>>, acc) do
    split_locators(rest, [locator | acc])
  end

  defp split_locators(<<>>, acc), do: Enum.reverse(acc)
end
