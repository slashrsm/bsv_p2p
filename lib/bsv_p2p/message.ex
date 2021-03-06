defmodule BsvP2p.Message do
  @moduledoc """
  Handles P2P messages.
  """
  alias BSV.Crypto.Hash
  alias BsvP2p.Command
  alias BsvP2p.Util.NetworkMagic

  @type t :: Command.Ping.t() | Command.Pong.t() | Command.Version.t() | Command.Verack.t()

  @spec parse(binary) ::
          {[{:ok, NetworkMagic.t(), __MODULE__.t()} | {:error, String.t()}], binary()}
  def parse(payload, acc \\ [])

  def parse(
        <<magic::binary-size(4), raw_command_name::binary-size(12), payload_size::size(32)-little,
          checksum::binary-size(4), payload::binary-size(payload_size), rest::binary>>,
        acc
      ) do
    if validate_checksum(checksum, payload) do
      try do
        network_magic = NetworkMagic.get_network(magic)
        command_name = String.trim(raw_command_name, <<0x00>>)
        command = get_command(command_name, payload)
        parse(rest, [{:ok, network_magic, command} | acc])
      rescue
        _ ->
          parse(rest, [
            {
              :error,
              "Invalid command: #{magic}, #{String.trim(raw_command_name, <<0x00>>)}, #{checksum}, #{
                payload
              }."
            }
            | acc
          ])
      end
    else
      parse(rest, [
        {
          :error,
          "Invalid checksum for '#{String.trim(raw_command_name, <<0x00>>)}': #{checksum} - #{
            payload
          }."
        }
        | acc
      ])
    end
  end

  def parse(rest, acc), do: {Enum.reverse(acc), rest}

  @spec create_payload(__MODULE__.t(), NetworkMagic.t()) :: binary
  def create_payload(command, network) do
    payload = Command.get_payload(command)
    <<checksum::binary-size(4)-little, _rest::binary>> = Hash.sha256_sha256(payload)

    NetworkMagic.get_magic(network) <>
      String.pad_trailing(Command.name(command), 12, <<0x00>>) <>
      <<byte_size(payload)::integer-size(32)-little>> <>
      checksum <>
      payload
  end

  @spec validate_checksum(<<_::32>>, binary) :: boolean()
  defp validate_checksum(valid_checksum, payload) do
    <<actual_checksum::binary-size(4)-little, _rest::binary>> = Hash.sha256_sha256(payload)

    valid_checksum == actual_checksum
  end

  @spec get_command(String.t(), binary) :: __MODULE__.t()
  for filename <- File.ls!("lib/bsv_p2p/command") do
    command_name = String.trim_trailing(filename, ".ex")

    if command_name !== "unknown" do
      module_name = String.to_atom("Elixir.BsvP2p.Command.#{String.capitalize(command_name)}")

      defp get_command(unquote(command_name), payload),
        do: unquote(module_name).from_payload(payload)
    end
  end

  defp get_command(unknown_name, unknown_payload),
    do: %Command.Unknown{name: unknown_name, payload: unknown_payload}
end
