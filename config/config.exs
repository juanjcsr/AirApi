# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :air_api, AirApi.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "Pr6eCmrOldDkUaYBzSU5UkiQmuA8N7CKqLNwCpQCQFC/kUbva3J4d+M/JV4oAbuh",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: AirApi.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false



config :guardian, Guardian,
  issuer: "AirApi.#{Mix.env}",
  hooks: GuardianDb,
  ttl: {30, :days},
  verify_issuer: true,
  serializer: AirApi.GuardianSerializer,
  secret_key: to_string(Mix.env),
  permissions: %{
    default: [
      :read_profile,
      :write_profile,
      :read_token,
      :revoke_token,
    ],
  }

config :guardian_db, GuardianDb,
  repo: AirApi.Repo,
  schema_name: "tokens" # Optional, default is "guardian_tokens"