defmodule TelemetryDemo.Telemetry do
  use GenServer
  require Logger

  @slow_query_threshold_ms 500

  def start_link(_arg) do
    GenServer.start_link(__MODULE__, %{})
  end

  @impl true
  def init(state) do
    :telemetry.attach(
      "repo-query-logger",
      [:telemetry_demo, :repo, :query],
      &__MODULE__.handle_repo_query_event/4,
      nil
    )

    Logger.info("✅ Telemetry handler attached for [:telemetry_demo, :repo, :query]")
    {:ok, state}
  end

  def handle_repo_query_event(_event_name, measurements, metadata, _config) do
    total_time_ms =
      System.convert_time_unit(measurements[:total_time], :native, :millisecond)

    if total_time_ms > @slow_query_threshold_ms do
      Logger.warning("""
      ⚠️ Slow query detected (#{total_time_ms}ms):
      #{inspect(metadata.query)}
      """)
    end
  end
end
