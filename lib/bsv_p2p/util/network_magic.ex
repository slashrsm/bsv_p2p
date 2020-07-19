defmodule BsvP2p.Util.NetworkMagic do
  @moduledoc """
  Handles network magic.
  """

  @type t :: :main | :tests | :stn | :regtest

  @doc """
  Gets magic bytes from the network.

  ## Examples

    iex> BsvP2p.Util.NetworkMagic.get_magic(:main)
    <<0xE3, 0xE1, 0xF3, 0xE8>>

    iex> BsvP2p.Util.NetworkMagic.get_magic(:test)
    <<0xF4, 0xE5, 0xF3, 0xF4>>

    iex> BsvP2p.Util.NetworkMagic.get_magic(:stn)
    <<0xFB, 0xCE, 0xC4, 0xF9>>

    iex> BsvP2p.Util.NetworkMagic.get_magic(:regtest)
    <<0xDA, 0xB5, 0xBF, 0xFA>>
  """
  @spec get_magic(__MODULE__.t()) :: <<_::32>>
  def get_magic(:main), do: <<0xE3, 0xE1, 0xF3, 0xE8>>
  def get_magic(:test), do: <<0xF4, 0xE5, 0xF3, 0xF4>>
  def get_magic(:stn), do: <<0xFB, 0xCE, 0xC4, 0xF9>>
  def get_magic(:regtest), do: <<0xDA, 0xB5, 0xBF, 0xFA>>

  @doc """
  Gets network from the magic bytes.

  ## Examples

    iex> BsvP2p.Util.NetworkMagic.get_network(<<0xE3, 0xE1, 0xF3, 0xE8>>)
    :main

    iex> BsvP2p.Util.NetworkMagic.get_network(<<0xF4, 0xE5, 0xF3, 0xF4>>)
    :test

    iex> BsvP2p.Util.NetworkMagic.get_network(<<0xFB, 0xCE, 0xC4, 0xF9>>)
    :stn

    iex> BsvP2p.Util.NetworkMagic.get_network(<<0xDA, 0xB5, 0xBF, 0xFA>>)
    :regtest
  """
  @spec get_network(<<_::32>>) :: __MODULE__.t()
  def get_network(<<0xE3, 0xE1, 0xF3, 0xE8>>), do: :main
  def get_network(<<0xF4, 0xE5, 0xF3, 0xF4>>), do: :test
  def get_network(<<0xFB, 0xCE, 0xC4, 0xF9>>), do: :stn
  def get_network(<<0xDA, 0xB5, 0xBF, 0xFA>>), do: :regtest
end
