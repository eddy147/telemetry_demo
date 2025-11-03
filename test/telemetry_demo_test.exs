defmodule TelemetryDemoTest do
  use ExUnit.Case
  doctest TelemetryDemo

  test "greets the world" do
    assert TelemetryDemo.hello() == :world
  end
end
