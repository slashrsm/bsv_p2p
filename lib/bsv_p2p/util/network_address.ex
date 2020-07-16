defmodule BsvP2p.Util.NetworkAddress do
  @moduledoc """
  Handles network addresses.
  """
  alias BsvP2p.Util.Services

  defstruct timestamp: DateTime.utc_now(),
            services: [:node_network],
            ip: "127.0.0.1",
            port: 8333

  @type t :: %__MODULE__{
          timestamp: DateTime.t(),
          services: [Services.t()],
          ip: String.t(),
          port: non_neg_integer
        }

  @spec get_payload(__MODULE__.t(), true) :: binary
  def get_payload(%__MODULE__{timestamp: timestamp} = address, true) do
    <<DateTime.to_unix(timestamp)::integer-unsigned-size(64)-little>> <>
      get_payload(address, false)
  end

  @spec get_payload(__MODULE__.t(), false) :: binary
  def get_payload(%__MODULE__{ip: ip, services: services, port: port}, false) do
    {:ok, {p1, p2, p3, p4, p5, p6, p7, p8}} = :inet.parse_ipv6_address(String.to_charlist(ip))

    Services.get_payload(services) <>
      <<p1::integer-size(16), p2::integer-size(16), p3::integer-size(16), p4::integer-size(16),
        p5::integer-size(16), p6::integer-size(16), p7::integer-size(16),
        p8::integer-size(16)>> <>
      <<port::integer-size(16)>>
  end

  @spec from_payload(binary) :: __MODULE__.t()
  def from_payload(
        <<timestamp::integer-unsigned-size(64)-little, services::binary-size(8),
          ip::binary-size(16), port::integer-size(16)>>
      ) do
    %__MODULE__{
      timestamp: DateTime.from_unix!(timestamp),
      services: Services.from_payload(services),
      ip: parse_ip(ip),
      port: port
    }
  end

  def from_payload(<<services::binary-size(8), ip::binary-size(16), port::integer-size(16)>>) do
    %__MODULE__{
      timestamp: DateTime.utc_now(),
      services: Services.from_payload(services),
      ip: parse_ip(ip),
      port: port
    }
  end

  @spec from_payload(binary, DateTime.t()) :: __MODULE__.t()
  def from_payload(
        <<services::binary-size(8), ip::binary-size(16), port::integer-size(16)>>,
        timestamp
      ) do
    %__MODULE__{
      timestamp: timestamp,
      services: Services.from_payload(services),
      ip: parse_ip(ip),
      port: port
    }
  end

  @spec parse_ip(<<_::128>>) :: String.t()
  defp parse_ip(
         <<ip1::integer-size(16), ip2::integer-size(16), ip3::integer-size(16),
           ip4::integer-size(16), ip5::integer-size(16), ip6::integer-size(16),
           ip7::integer-size(16), ip8::integer-size(16)>>
       ) do
    case :inet.ntoa({ip1, ip2, ip3, ip4, ip5, ip6, ip7, ip8}) do
      {:error, _} -> raise ArgumentError, message: "Unable to parse IP"
      ip -> to_string(ip) |> String.replace_leading("::ffff:", "")
    end
  end
end
