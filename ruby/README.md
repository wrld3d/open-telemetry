# OpenTelemetry - Ruby SDK

### Gemfile

Source the gems required for OpenTelemetry, by adding the following to the
application's Gemfile
```ruby
# Add gems for OpenTelemetry
Dir.glob(File.join(File.dirname(__FILE__), 'open-telemetry/ruby', 'Gemfile')) do |gemfile|
   instance_eval File.read(gemfile)
end
```

Run `bundle install` to update the gems in the main `Gemfile.lock`.

## Entrypoint

Add the following line to the entrypoint of the Ruby application
```ruby
require File.join(File.dirname(__FILE__), './open-telemetry/ruby/configuration')
```

## Docker

If the application uses Docker, it will probably need to install some gems through bundler. If that's the case, add the following line to the Dockerfile, which will allow bundler to find the required gems for OpenTelemetry as well

```dockerfile
COPY open-telemetry ./open-telemetry
```
