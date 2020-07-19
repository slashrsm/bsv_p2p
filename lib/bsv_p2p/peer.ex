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

  def start_link do
    # We need Connection.start_link/2 now,
    # not GenServer.start_link/2
    Connection.start_link(__MODULE__, %{socket: nil, network: :main, rest: <<>>})
  end

  def init(state) do
    # We use `nil` as we don't need any additional info
    # to connect
    {:connect, nil, state}
  end

  def connect(_info, state) do
    opts = [:binary, active: :once]
    {:ok, socket} = :gen_tcp.connect('localhost', 8333, opts)

    :ok = send_version(socket, state.network)

    {:ok, %{state | socket: socket}}
  end

  # def handle_call({:command, _cmd}, from, %{queue: queue} = state) do
  #  :ok = :gen_tcp.send(state.socket, <<>>)

  #  state = %{state | queue: :queue.in(from, queue)}

  #  {:noreply, state}
  # end

  def handle_info({:tcp, socket, message}, %{network: network} = state) do
    :inet.setopts(socket, active: :once)
    # Logger.debug("#{display_message(message)}")

    {commands, rest} = (state.rest <> message) |> BsvP2p.Message.parse()

    commands
    |> Enum.each(fn
      {:ok, ^network, %Command.Unknown{name: name, payload: payload}} ->
        Logger.debug("Unknown message: #{name}, #{display_message(payload)}")

      {:ok, ^network, command} ->
        Logger.debug("Got message: #{Command.name(command)}")
        process_command(command, socket, network)

      {:error, reason} ->
        Logger.debug("Unable to process command: #{reason}")
    end)

    {:noreply, %{state | rest: rest}}
  end

  @spec process_command(Message.t(), port(), NetworkMagic.t()) :: :ok | {:error, atom()}
  defp process_command(%Command.Ping{nonce: nonce}, socket, network) do
    send_command(%Command.Pong{nonce: nonce}, socket, network)
  end

  defp process_command(%Command.Version{}, socket, network) do
    send_command(%Command.Verack{}, socket, network)
  end

  defp process_command(%Command.Verack{}, _socket, _network) do
    # %Command.Getheaders{}
    # |> Command.Getheaders.set_locator_hashes("000000000000000000a3524a6ab7e3220a55acf6062c5a6e7e7f212450e5d0c6")
    # |> Command.Getheaders.set_stop_hash(
    #  "000000006a625f06636b8bb6ac7b960a8d03705d1ace08b1a19da3fdcc99ddbd"
    # )
    # |> send_command(socket, network)

    # %Command.Getaddr{}
    # |> send_command(socket, network)

    # %Command.Getdata{
    #   vectors: [%BsvP2p.Util.InventoryVector{
    #     type: :transaction,
    #     hash:
    #       Base.decode16!("4D045B7E08DBB3E4A19F98DA0772F3FD43EB0E7F036ABA34B16867BE3D93E358")
    #       |> BSV.Util.reverse_bin()
    #   }]
    # }
    # |> send_command(socket, network)
  end

  # defp process_command(%Command.Tx{} = command, _socket, _network) do
  #    IO.inspect(command)
  #    :ok
  # end

  defp process_command(_, _socket, _network), do: :ok

  @spec send_version(port(), NetworkMagic.t()) :: :ok | {:error, atom()}
  defp send_version(socket, network) do
    send_command(
      %Command.Version{
        version: 70_015,
        services: [:node_network],
        nonce: BSV.Util.random_bytes(8),
        timestamp: DateTime.utc_now(),
        user_agent: "/bsv_p2p:0.1.0/",
        latest_block: 0,
        recipient: %NetworkAddress{},
        sender: %NetworkAddress{},
        relay: 1
      },
      socket,
      network
    )
  end

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
end
