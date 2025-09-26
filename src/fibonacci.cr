require "opentelemetry-sdk"
require "http/server"
require "big/big_int"

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

class Fibonacci
  VERSION = "1.0.0"
  #private getter finished : Channel(Nil) = Channel(Nil).new
  getter finished : Channel(Nil)= Channel(Nil).new

  # This implements an iterative solution to solving for a given
  # fibonacci number. This function will also utilize BigInt, which
  # is an arbitrary precision integer, if the answer will be too large
  # to fit into a 64 bit Integer.
  def fibonacci(x)
    OpenTelemetry.tracer.in_span("Calculate Fibonacci ##{x}") do |span|
      span.producer!
      span.add_event("Entered Fibonacci function")
      if x > 39196 # The answer is too big to fit within data size limits for a span.
        raise "Error. Fibonacci calculations greater than 39196 are disallowed because the answer is too large to fit into an OpenTelemetry span. The #{x} Fibonacci number was requested."
      end

      a, b = x > 93 ? {BigInt.new(0), BigInt.new(1)} : {0_u64, 1_u64}

      (x - 1).times do
        a, b = b, a + b
      end

      # You generally won't manually add spans like this. Auto-instrumentation is the new rage!
      span.set_attribute("fibonacci.n", "#{x}")
      span.set_attribute("fibonacci.result", "#{a}")

      # Create a child span
      span.add_event("dispatching to handler")
      OpenTelemetry.tracer.in_span("handler") do |child_span|
        child_span.add_event("sleeping for a random time")
        sleep rand(0.2..0.5).seconds
        a
      end  # child_span
    end    # end span
  end      # end def

  # In this example, the HTTP server that handles fibonacci requests
  # is spawned into it's own fiber. This example would work just fine
  # if it were kept in the main thread, but this pattern can be useful
  # in larger applications.

  # This example could be much shorter, but it represents a more typical
  # application pattern, with handlers for managing errors, for logging
  # responses, and for automatically compressing the response, if the
  # request allows for it in the *Accept-Encoding* header.
  def run
    spawn(name: "Fibonacci Server") do
      server = HTTP::Server.new([
        HTTP::ErrorHandler.new,
        HTTP::LogHandler.new,
        HTTP::CompressHandler.new,
      ]) do |context|
        n = context.request.query_params["n"]?  # I should declare n float. ERROR on float input

        if n && n.to_i > 0
          answer = fibonacci(n.to_i)
          context.response << answer.to_s
          context.response.content_type = "text/plain"
        else
          context.response.respond_with_status(400,
            "Please provide a positive integer as the 'n' query parameter")
        end
      end  # context block

      # Listen on default socket and ENV PORT
      bind = "0.0.0.0"
      ENV["PORT"] ||= "8080"
      port = ENV["PORT"].to_i
      address = server.bind_tcp(bind, port)
      puts "Listening on http://#{address}"
      server.listen
    end  # spawn

    self
  end  # def run

  # This is not strictly necessary, but in a larger application, one
  # might want to have the main fiber wait for the fiber that is running
  # the server to finish, and if it does so, cleanup resources. This
  # pattern is a simple one to allow that.
  def wait
    finished.receive
    # Fiber.yield
  end
end     # class
