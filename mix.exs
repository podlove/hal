defmodule HAL.MixProject do
  use Mix.Project

  def project do
    [
      app: :hal,
      version: "1.0.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "HAL",
      source_url: "https://github.com/podlove/hal",
      # homepage_url: "http://YOUR_PROJECT_HOMEPAGE",
      description: "Generate JSON in HAL format for REST APIs.",
      package: package(),
      docs: [
        # The main page in the docs
        main: "readme",
        # logo: "path/to/logo.png",
        extras: ["README.md"]
      ]
    ]
  end

  defp package() do
    [
      maintainers: ["Eric Teubert"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/podlove/hal"}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.1"},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
