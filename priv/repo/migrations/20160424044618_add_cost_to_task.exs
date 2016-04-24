defmodule AirApi.Repo.Migrations.AddCostToTask do
  use Ecto.Migration

  def change do
    alter table(:todos) do
        add :cost, :float
    end
  end
end
