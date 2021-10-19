#!/bin/sh

if [ -z "$SERVICE_ENV" ]; then
    echo "Service environment not detected, or development env."
    echo "OpenTelemetry Collector process WILL NOT be started."
    exit 0
fi

# https://stackoverflow.com/a/4774063/5874339
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

###########################
# OpenTelemetry Collector #
###########################
version="v0.36.0"
binary_name="otelcontribcol_linux_amd64"
binary_url="https://github.com/open-telemetry/opentelemetry-collector-contrib/releases/download/$version/$binary_name"

# Create versioned binary name
output_binary_name=$(echo "${binary_name}_${version}" | tr -d '.')

binary_path="$SCRIPTPATH/$output_binary_name"
config_file_path="$SCRIPTPATH/otel-collector-config.yaml"

# Download binary, if it doesn't exist
if [ ! -f "$binary_path" ]; then
    echo "Downloading $binary_name $version"
    curl -L --silent "$binary_url" --output "$binary_path"
fi

# Make binary executable
chmod +x "$binary_path"

# Run in background with the provided config
echo "Starting OpenTelemetry Collector in background"
"$binary_path" --config "$config_file_path" &
