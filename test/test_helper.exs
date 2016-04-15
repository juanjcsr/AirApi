ExUnit.start

Mix.Task.run "ecto.create", ~w(-r AirApi.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r AirApi.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(AirApi.Repo)

