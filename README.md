# OpenTelemetry

This repository contains the necessary components to add the OpenTelemetry SDK
to WRLD services and applications, allowing us to generate traces & metrics,
and the OpenTelemetry Collector, which allows us to collect and _export_
them to another service, e.g. Datadog, for visualization and alerting.

## Integration

For specific details about how to ingrate the SDK with existing applications
or services, please refer to the specific README for each SDK.

- [Ruby](./ruby/README.md)

## OpenTelemetry Collector

> The OpenTelemetry Collector offers a vendor-agnostic implementation on how to receive, process, and export telemetry data. It removes the need to run, operate, and maintain multiple agents/collectors in order to support open-source observability data formats (e.g. Jaeger, Prometheus, etc.) sending to one or more open-source or commercial back-ends.

### Configuration

The [configuration file](./otel-collector-config.yaml) controls how the data
is collected, transformed, and then exported to other services.
You can read more on how the process works
[here](https://opentelemetry.io/docs/concepts/data-collection/).


In order for the OpenTelemetry Collector to correctly tag traces for each
service, you will need to configure the following environment variables,
which are then used in the configuration file mentioned above
```yaml
- SERVICE_NAME="REPLACE_WITH_SERVICE_OR_APP_NAME"
- SERVICE_ENV="REPLACE_WITH_SERVICE_OR_APP_ENV"
- OTEL_EXPORTER_OTLP_ENDPOINT=http://0.0.0.0:4318
- DD_API_KEY="REPLACE_WITH_REAL_API_KEY"  # <-- necessary when exporting to Datadog
```

If you need to run multiple services on the same host/container,
you will probably need to make a few changes, 
such as setting the service name from the SDK initialization code block,
e.g. [example config for Ruby](https://opentelemetry.io/docs/ruby/getting_started/#initialization)

### Collector Process

The OpenTelemetry Collector can be started on the host using the
[shell script](./start-otel-collector.sh), which downloads the specified
version of the binary and runs it in background,
using the [configuration file](./otel-collector-config.yaml).

To automatically start the process on services like Heroku, you can add the script to the Procfile (e.g. Ruby)
```ruby
web: ./open-telemetry/start-otel-collector.sh; bundle exec rerun --background --force-polling -- ruby api-key-service.rb -o 0.0.0.0 -s Puma
```

This is the approach Heroku
[suggests](https://help.heroku.com/CTFS2TJK/how-do-i-run-multiple-processes-on-a-dyno)
for running multiple processes on the same dyno.
