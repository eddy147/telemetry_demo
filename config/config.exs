import Config

config :telemetry_demo, TelemetryDemo.Repo,
  database: "td_pg_dev",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10,
  telemetry_prefix: [:telemetry_demo, :repo]


config :telemetry_demo, ecto_repos: [TelemetryDemo.Repo]
