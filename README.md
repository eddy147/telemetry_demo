# TelemetryDemo

```bash
Ecto → :telemetry events → TelemetryMetricsPrometheus
                            ↓
                      /metrics endpoint
                            ↓
                   Prometheus server scrapes
                            ↓
                  Grafana dashboard + alerts

Ecto → :telemetry events → custom handler
                            ↓
                          Logger
                            ↓
                         Loki (logs)

```

## Testing slow queries

```bash
iex -S mix
Erlang/OTP 27 [erts-15.2] [source] [64-bit] [smp:16:16] [ds:16:16:10] [async-threads:1] [jit:ns]

Compiling 3 files (.ex)
Generated telemetry_demo app

14:43:26.908 [info] ✅ Telemetry handler attached for [:telemetry_demo, :repo, :query]
Interactive Elixir (1.18.1) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> TelemetryDemo.Repo.query!("SELECT pg_sleep(1)")

14:43:36.304 [warning] ⚠️ Slow query detected (1005ms):
"SELECT pg_sleep(1)"


14:43:36.304 [warning] ⚠️ Slow query (1005ms): "SELECT pg_sleep(1)"

14:43:36.306 [debug] QUERY OK db=1002.7ms decode=1.7ms queue=0.9ms idle=421.0ms
SELECT pg_sleep(1) []
%Postgrex.Result{
  command: :select,
  columns: ["pg_sleep"],
  rows: [[:void]],
  num_rows: 1,
  connection_id: 751,
  messages: []
}
```

See http://localhost:9568/metrics

```sql
# HELP telemetry_demo_repo_query_slow_count
# TYPE telemetry_demo_repo_query_slow_count counter
telemetry_demo_repo_query_slow_count 2
# HELP telemetry_demo_repo_query_count
# TYPE telemetry_demo_repo_query_count counter
telemetry_demo_repo_query_count 2
# HELP telemetry_demo_repo_query_total_time Total query execution time in ms
# TYPE telemetry_demo_repo_query_total_time histogram
telemetry_demo_repo_query_total_time_bucket{le="1"} 0
telemetry_demo_repo_query_total_time_bucket{le="5"} 0
telemetry_demo_repo_query_total_time_bucket{le="10"} 0
telemetry_demo_repo_query_total_time_bucket{le="50"} 0
telemetry_demo_repo_query_total_time_bucket{le="100"} 0
telemetry_demo_repo_query_total_time_bucket{le="200"} 0
telemetry_demo_repo_query_total_time_bucket{le="500"} 0
telemetry_demo_repo_query_total_time_bucket{le="1000"} 0
telemetry_demo_repo_query_total_time_bucket{le="2000"} 1
telemetry_demo_repo_query_total_time_bucket{le="+Inf"} 2
telemetry_demo_repo_query_total_time_sum 3010.44311
telemetry_demo_repo_query_total_time_count 2
```

(At this time I did also a query with pg_sleep(2)) hence the count is 2)


