defmodule BsvP2p.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # %{
      #  id: BsvP2p,
      #  start: {BsvP2p, :start_link, []}
      # }
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BsvP2p.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
