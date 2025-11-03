defmodule TelemetryDemo.Repo do
  use Ecto.Repo,
    otp_app: :telemetry_demo,
    adapter: Ecto.Adapters.Postgres
end
