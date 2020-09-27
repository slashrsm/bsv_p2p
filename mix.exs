defmodule BsvP2p.MixProject do
  use Mix.Project

  defp description do
    "Bitcoin SV server network client."
  end

  def project do
    [
      app: :bsv_p2p,
      version: "0.1.0-alpha2",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      source_url: "https://github.com/slashrsm/bsv_p2p",
      deps: deps(),
      description: description(),
      package: package(),
      elixirc_options: [warnings_as_errors: true],
      dialyzer: [
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"},
        ignore_warnings: ".dialyzer_ignore.exs"
      ],
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {BsvP2p.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_check, ">= 0.0.0", only: :dev, runtime: false},
      {:credo, ">= 0.0.0", only: :dev, runtime: false},
      {:dialyxir, ">= 0.0.0", only: :dev, runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:sobelow, ">= 0.0.0", only: :dev, runtime: false},
      {:mock, "~> 0.3.5", only: :test},
      {:excoveralls, "~> 0.10", only: :test},
      {:connection, "~> 1.0.4"},
      #{:bsv, github: "slashrsm/bsv-ex"}
      {:bsv, "~> 0.2.6"},
    ]
  end

  defp package do
    [
      maintainers: ["Janez Urevc"],
      licenses: ["MIT"],
      links: %{github: "https://github.com/slashrsm/bsv_p2p"},
      files: ~w(lib LICENSE.md mix.exs README.md)
    ]
  end
end
