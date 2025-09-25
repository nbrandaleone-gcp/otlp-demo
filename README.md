# otlp-demo

September 2025

This demo project shows how to use the Crystal language and Open Telemetry (OTLP) 
to send metrics and logs to both a local collector (Jaeger) and when running on Google Cloud Run.

A Cloud Run service can only report custom OTLP metrics to Google Cloud Managed Service for Prometheus by using the Google-Built OpenTelemetry Collector as a sidecar. Logs and Traces
are forwarded to Cloud Logging and Cloud Trace as expected.

There is a private preview of OTLP metrics on Google Cloud Monitoring.
This preview only supports metrics, and not logs. I will experiment with it, and
perhaps publish an updated blog regarding its features.

The crystal OTLP library was created by an engineer at New Relic, and wrote up
a blog which is the basis of this repo.
Based upon blog: https://medium.com/notes-and-tips-in-full-stack-development/how-to-begin-with-traces-in-crystal-2fd6a0255447

## Installation

TODO: Write installation instructions here

## Usage

TODO: Write usage instructions here

## Development

## Test
curl "http://127.0.0.1:8080/?n=37"

## Appendix and sources
Open Telemetry
- https://opentelemetry.io/
- https://opentelemetry.io/docs/languages/ruby/exporters/

New Relic blog and sources
- https://github.com/newrelic-experimental/mcv3-apps/blob/kh.add-crystal-example-20220412/Instrumented/crystal/src/fibonacci.cr
- https://github.com/wyhaines/opentelemetry-instrumentation.cr
- https://github.com/wyhaines/opentelemetry-sdk.cr
- https://github.com/wyhaines/opentelemetry-api.cr

Honeycomb OTLP library
- https://github.com/jgaskins/opentelemetry
- https://dev.to/fdocr/deploy-a-crystal-app-with-docker-and-opentelemetry-24cp

Jaeger
- https://www.jaegertracing.io/docs/next-release/deployment/

## Contributing

1. Fork it (<https://github.com/your-github-user/otlp-demo/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Nick Brandaleone](https://github.com/your-github-user) - creator and maintainer
