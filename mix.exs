defmodule SafeCode.MixProject do
  use Mix.Project

  def project do
    [
      app: :safe_code,
      description: "Validate if code is safe to load and run",
      version: "0.2.3",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      source_url: "https://github.com/TheFirstAvenger/safe_code",
      deps: deps(),
      package: package(),
      dialyzer: [
        ignore_warnings: ".dialyzer_ignore.exs",
        list_unused_filters: true,
        plt_file: {:no_warn, "plts/safe_code.plt"}
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/TheFirstAvenger/safe_code"}
    ]
  end

  defp deps do
    [
      {:mix_test_watch, "~> 1.1", only: :dev, runtime: false},
      {:phoenix_live_view, ">= 0.18.17"},
      {:jason, "~> 1.3"},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.2", only: [:dev, :test], runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end
end
