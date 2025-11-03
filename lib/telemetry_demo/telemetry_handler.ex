defmodule TelemetryDemo.TelemetryHandler do
  use GenServer
  require Logger

  @threshold_ms 500

  def start_link(_), do: GenServer.start_link(__MODULE__, %{})

  @impl true
  def init(state) do
    :telemetry.attach("slow-query-detector", [:telemetry_demo, :repo, :query], &__MODULE__.handle/4, nil)
    {:ok, state}
  end

  def handle(_event, measurements, metadata, _config) do
    total_time_ms = System.convert_time_unit(measurements[:total_time], :native, :millisecond)

    if total_time_ms > @threshold_ms do
      # log to Loki via standard Logger
      Logger.warning("⚠️ Slow query (#{total_time_ms}ms): #{inspect(metadata.query)}")

      # also increment a Prometheus counter via telemetry event
      :telemetry.execute(
        [:telemetry_demo, :repo, :query, :slow],
        %{count: 1},
        %{query: metadata.query, time_ms: total_time_ms}
      )
    end
  end
end
