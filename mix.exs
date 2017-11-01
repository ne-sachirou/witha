defmodule Witha.Mixfile do
  use Mix.Project

  def project do
    [
      app: :witha,
      deps: deps(),
      description: "With aspect: Monad chain, like Haskell's `do` or Clojure's `cats.core/alet`.",
      elixir: "~> 1.4",
      package: package(),
      start_permanent: Mix.env == :prod,
      version: "0.1.1",
      # Docs
      docs: [
        main: "readme",
        extras: ["README.md"],
      ],
      homepage_url: "https://github.com/ne-sachirou/witha",
      name: "Witha",
      source_url: "https://github.com/ne-sachirou/witha",
    ]
  end

  def application, do: [extra_applications: []]

  defp deps do
    [
      {:ex_doc, "~> 0.18", only: :dev, runtime: false},
      {:inner_cotton, github: "ne-sachirou/inner_cotton", only: [:dev, :test]},
    ]
  end

  defp package do
    [
      files: ["LICENSE", "README.md", "mix.exs", "lib"],
      licenses: ["GPL-3.0"],
      links: %{
        "GitHub": "https://github.com/ne-sachirou/witha",
      },
      maintainers: ["ne_Sachirou <utakata.c4se@gmail.com>"],
      name: :witha,
    ]
  end
end
