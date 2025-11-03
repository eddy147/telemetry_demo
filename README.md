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



