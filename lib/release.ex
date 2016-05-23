defmodule AirApi.ReleaseTasks do
  @moduledoc ~S"""
  Mix is not available in a built release. Instead we define the tasks here,
  and invoke it using the application script generated in the release:

      bin/wolf command Elixir.AirApi.ReleaseTasks create
      bin/wolf command Elixir.AirApi.ReleaseTasks migrate
      bin/wolf command Elixir.AirApi.ReleaseTasks seed
      bin/wolf command Elixir.AirApi.ReleaseTasks drop
  """

  def create do
    repo = AirApi.Repo
    load_app()
    info "Creating database for #{inspect repo}.."
    case Ecto.Storage.up(repo) do
      :ok ->
        info "The database for #{inspect repo} has been created."
      {:error, :already_up} ->
        info "The database for #{inspect repo} has already been created."
      {:error, term} when is_binary(term) ->
        fatal "The database for #{inspect repo} couldn't be created, reason given: #{term}."
      {:error, term} ->
        fatal "The database for #{inspect repo} couldn't be created, reason given: #{inspect term}."
    end
    System.halt(0)
  end

  def drop do
    repo = AirApi.Repo
    load_app()
    info "Dropping database for #{inspect repo}.."
    case Ecto.Storage.down(repo) do
      :ok ->
        info "The database for #{inspect repo} has been dropped."
      {:error, :already_down} ->
        info "The database for #{inspect repo} has already been dropped."
      {:error, term} when is_binary(term) ->
        fatal "The database for #{inspect repo} couldn't be dropped, reason given: #{term}."
      {:error, term} ->
        fatal "The database for #{inspect repo} couldn't be dropped, reason given: #{inspect term}."
    end
    System.halt(0)
  end

  def migrate do
    IO.inspect "Starting Migrations..."
    repo = AirApi.Repo
    start_repo(repo)
    migrations_path = Application.app_dir(:air_api, "priv/repo/migrations")
    info "Executing migrations for #{inspect repo} in #{migrations_path}:"
    migrations = Ecto.Migrator.run(repo, migrations_path, :up, all: true)
    info "Applied versions: #{inspect migrations}"
    System.halt(0)
  end

  def seed do
    repo = AirApi.Repo
    start_repo(repo)
    info "Seeding data for #{inspect repo}.."
    # Put any needed seeding data here, or maybe run priv/repo/seeds.exs
    System.halt(0)
  end

  defp start_applications(apps) do
    Enum.each(apps, fn app ->
      {:ok, _} = Application.ensure_all_started(app)
    end)
  end

  defp start_repo(repo) do
    load_app()
    {:ok, _} = repo.start_link()
  end

  defp load_app do
    start_applications([:logger, :postgrex, :ecto])
    :ok = Application.load(:air_api)
  end

  defp info(message) do
    IO.puts(message)
  end

  defp fatal(message) do
    IO.puts :stderr, message
    System.halt(1)
  end
end