defmodule SafeCode.MixProject do
  use Mix.Project

  def project do
    [
      app: :safe_code,
      description: "Validate if code is safe to load and run",
      version: "0.2.2",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      source_url: "https://github.com/TheFirstAvenger/safe_code",
      deps: deps(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
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

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:mix_test_watch, "~> 1.1.0", env: :dev, runtime: false},
      {:phoenix_live_view, "~> 0.17.5"},
      {:jason, "~> 1.3.0"},
      {:credo, "~> 1.6.1", only: [:dev, :test], runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
