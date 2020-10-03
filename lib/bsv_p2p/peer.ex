defmodule BsvP2p.Peer do
  @moduledoc """
  Connects to a network peer.
  """

  use Connection
  require Logger
  alias BsvP2p.Command
  alias BsvP2p.Message
  alias BsvP2p.Util.NetworkAddress
  alias BsvP2p.Util.NetworkMagic

  @type state :: %{
          socket: port(),
          status: :connecting | :connected | :disconnected,
          sent_version: Command.Version.t(),
          recv_version: Command.Version.t(),
          protoconf: Command.Protoconf.t(),
          host: String.t(),
          port: non_neg_integer(),
          network: NetworkMagic.t(),
          rest: binary()
        }

  def start_link(options \\ []) do
    host = Keyword.get(options, :host, "localhost")
    port = Keyword.get(options, :port, 8333)
    network = Keyword.get(options, :network, :main)

    Connection.start_link(__MODULE__, %{
      socket: nil,
      status: :connecting,
      sent_version: nil,
      recv_version: nil,
      protoconf: nil,
      host: host,
      port: port,
      network: network,
      rest: <<>>
    })
  end

  def init(state) do
    {:connect, nil, state}
  end

  @spec connect(any, state()) :: {:ok, state()}
  def connect(_info, state) do
    {:ok, socket} =
      :gen_tcp.connect(String.to_charlist(state.host), state.port, [:binary, active: :once])

    state = %{state | socket: socket}
    {:ok, version} = send_version(state)

    {:ok, %{state | sent_version: version}}
  end

  @spec send_version(state()) :: {:ok, Command.Version.t()}
  defp send_version(state) do
    {:ok, {:hostent, _, _, _, _, [ip_address | _]}} =
      :inet.gethostbyname(String.to_charlist(state.host))

    command = %Command.Version{
      version: 70_015,
      services: [:node_network],
      nonce: BSV.Util.random_bytes(8),
      timestamp: DateTime.utc_now(),
      user_agent: "/bsv_p2p:0.1.0/",
      latest_block: 0,
      recipient: %NetworkAddress{
        ip: ip_address |> :inet.ntoa() |> List.to_string(),
        port: state.port
      },
      # TODO how do we see ourselves
      sender: %NetworkAddress{},
      relay: true
    }

    :ok = send_command(command, state.socket, state.network)
    {:ok, command}
  end

  @spec handle_info({:tcp, port(), binary()}, state()) ::
          {:noreply, any}
          | {:noreply, any, timeout | :hibernate}
          | {:disconnect | :connect, any, any}
          | {:stop, any, any}
  def handle_info({:tcp, socket, message}, %{network: network} = state) do
    :inet.setopts(socket, active: :once)
    # Logger.debug("#{display_message(message)}")

    {commands, rest} = (state.rest <> message) |> BsvP2p.Message.parse()

    {
      :noreply,
      process_commands(commands, network, %{state | rest: rest})
    }
  end

  @spec process_commands(
          [{:ok, NetworkMagic.t(), Message.t()} | {:error, String.t()}],
          NetworkMagic.t(),
          state()
        ) :: state()
  def process_commands([], _, state), do: state

  def process_commands(
        [{:ok, command_network, %Command.Unknown{name: name, payload: payload}} | rest],
        network,
        state
      )
      when command_network == network do
    Logger.warn("Unknown message: #{name}, #{display_message(payload)}")
    process_commands(rest, network, state)
  end

  def process_commands([{:ok, command_network, command} | rest], network, state)
      when command_network == network do
    Logger.debug("Got message: #{Command.name(command)}")
    state = process_command(command, state)
    process_commands(rest, network, state)
  end

  def process_commands([{:error, reason} | rest], network, state) do
    Logger.error("Unable to process command: #{reason}")
    process_commands(rest, network, state)
  end

  @spec process_command(Message.t(), map()) :: map()
  defp process_command(%Command.Ping{nonce: nonce}, state) do
    send_command(%Command.Pong{nonce: nonce}, state.socket, state.network)
    state
  end

  defp process_command(%Command.Version{} = recv_version, state) do
    :ok = send_command(%Command.Verack{}, state.socket, state.network)
    %{state | recv_version: recv_version}
  end

  defp process_command(%Command.Verack{}, state) do
    %{state | status: :connected}
  end

  defp process_command(%Command.Protoconf{} = protoconf, state) do
    %{state | protoconf: protoconf}
  end

  defp process_command(_, state), do: state

  @spec send_command(Message.t(), port(), NetworkMagic.t()) :: :ok | {:error, atom()}
  defp send_command(command, socket, network) do
    Logger.debug("Sending message: #{Command.name(command)}")
    :gen_tcp.send(socket, Message.create_payload(command, network))
  end

  @spec display_message(binary) :: String.t()
  def display_message(msg) do
    Base.encode16(msg) |> split_every_4()
  end

  @spec split_every_4(String.t()) :: String.t()
  defp split_every_4(""), do: ""

  defp split_every_4(str) do
    {part, rest} = String.split_at(str, 4)
    part <> " " <> split_every_4(rest)
  end

  # defp process_command(%Command.Block{} = command, _socket, state) do
  # %Command.Getheaders{}
  # |> Command.Getheaders.set_locator_hashes("000000000000000000a3524a6ab7e3220a55acf6062c5a6e7e7f212450e5d0c6")
  # |> Command.Getheaders.set_stop_hash(
  #  "000000006a625f06636b8bb6ac7b960a8d03705d1ace08b1a19da3fdcc99ddbd"
  # )
  # |> send_command(socket, state.network)

  # %Command.Getaddr{}
  # |> send_command(socket, state.network)

  # %Command.Getdata{
  #   vectors: [%BsvP2p.Util.InventoryVector{
  #     type: :transaction,
  #     hash:
  #       Base.decode16!("4D045B7E08DBB3E4A19F98DA0772F3FD43EB0E7F036ABA34B16867BE3D93E358")
  #       |> BSV.Util.reverse_bin()
  #   }]
  # }
  # |> send_command(socket, network)

  # :ok = %Command.Getdata{
  #   vectors: [
  #     %BsvP2p.Util.InventoryVector{
  #       type: :block,
  #       hash:
  #         Base.decode16!("00000000839A8E6886AB5951D76F411475428AFC90947EE320161BBF18EB6048")
  #         |> BSV.Util.reverse_bin()
  #     }
  #   ]
  # }
  # |> send_command(socket, state.network)

  #   IO.inspect(command)
  #   {:noreply, state}
  # end
end
