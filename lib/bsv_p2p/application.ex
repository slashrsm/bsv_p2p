defmodule BsvP2p.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # %{
      #   id: BsvP2p.Peer,
      #   start:
      #     {BsvP2p.Peer, :start_link,
      #      [
      #        [
      #          # host: "34.217.97.100",
      #          host: "localhost",
      #          port: 8333,
      #          network: :main
      #        ]
      #      ]}
      # }
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BsvP2p.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
