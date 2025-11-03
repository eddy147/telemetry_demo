defmodule TelemetryDemo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TelemetryDemo.Repo,
      {TelemetryMetricsPrometheus,
       metrics: TelemetryDemo.Telemetry.metrics(), port: 9568, ip: {127, 0, 0, 1}},
      TelemetryDemo.Telemetry,
      # handler for slow queries
      TelemetryDemo.TelemetryHandler
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TelemetryDemo.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
