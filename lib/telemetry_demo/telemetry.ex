defmodule TelemetryDemo.Telemetry do
  use GenServer
  import Telemetry.Metrics
  require Logger

  @slow_query_threshold_ms 500

  def metrics do
    [
      # Histogram of query times
      distribution("telemetry_demo.repo.query.total_time",
        unit: {:native, :millisecond},
        reporter_options: [buckets: [1, 5, 10, 50, 100, 200, 500, 1000, 2000]],
        description: "Total query execution time in ms"
      ),

      # Total query count
      counter("telemetry_demo.repo.query.count"),

      # Slow queries counter (incremented manually in handler)
      counter("telemetry_demo.repo.query.slow_count")
    ]
  end

  def start_link(_arg) do
    GenServer.start_link(__MODULE__, %{})
  end

  @impl true
  def init(state) do
    # Attach to all Repo queries
    :telemetry.attach(
      "telemetry-demo-repo-handler",
      [:telemetry_demo, :repo, :query],
      &__MODULE__.handle_repo_query_event/4,
      nil
    )

    Logger.info("✅ Telemetry handler attached for [:telemetry_demo, :repo, :query]")
    {:ok, state}
  end

  @doc """
  Telemetry handler
  """
  def handle_repo_query_event(_event_name, measurements, metadata, _config) do
    total_time_ms =
      System.convert_time_unit(measurements[:total_time], :native, :millisecond)

    # Log slow queries
    if total_time_ms > @slow_query_threshold_ms do
      Logger.warning("""
      ⚠️ Slow query detected (#{total_time_ms}ms):
      #{inspect(metadata.query)}
      """)

      # Increment slow query counter for Prometheus
      :telemetry.execute(
        [:telemetry_demo, :repo, :query, :slow],
        %{count: 1},
        %{query: metadata.query, time_ms: total_time_ms}
      )
    end
  end
end
