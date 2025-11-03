defmodule TelemetryDemo.MixProject do
  use Mix.Project

  def project do
    [
      app: :telemetry_demo,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {TelemetryDemo.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, "~> 3.11"},
      {:postgrex, ">= 0.0.0"},
      {:plug_cowboy, "~> 2.6"},
      {:telemetry, "~> 1.2"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_metrics_prometheus, "~> 1.1"}
    ]
  end
end
