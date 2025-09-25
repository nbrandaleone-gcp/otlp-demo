require "./fibonacci"
# This stub instantiates an instance of the Fibonacci server, and runs it.

OpenTelemetry.configure do |config|
  config.service_name = "Fibonacci Server"
  config.service_version = Fibonacci::VERSION
  config.sampler = OpenTelemetry::Sampler::AlwaysOn.new
  config.exporter = OpenTelemetry::Exporter.new(variant: "http") do |c|
    # NOTICE: It allows to flush spans faster and not to wait for 100 spans or 5 seconds
    cc = c.as(OpenTelemetry::Exporter::Http)
    cc.endpoint = "http://localhost:4318/v1/traces"
    cc.batch_threshold = 5
    cc.batch_latency = 1
  end
end

# Handle Ctrl+C (SIGTERM) and kill (SIGKILL) signal.
# Cloud Run gives containers a 10 second window to clean-up with a SIGTERM signal.
Signal::INT.trap  do
  puts "Caught SIGINT. Cleaning up."
  sleep(Time::Span.new(seconds: 5))
  spawn { exit 0 }
end
Signal::TERM.trap { puts "Caught kill. Shutting down."; spawn { exit 0 } }

Fibonacci.new.run.wait
