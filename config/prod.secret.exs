use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
#config :air_api, AirApi.Endpoint,
  #secret_key_base: System.get_env("SECRET_KEY_BASE")

# Configure your database
config :air_api, AirApi.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "${DATABASE_USERNAME}",
  password: "${DATABASE_PASSWORD}",
  database: "air_api_prod",
  size: 20 # The amount of database connections in the pool
