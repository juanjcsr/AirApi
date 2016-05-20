defmodule AirApi.Todo do
  use AirApi.Web, :model
  import Ecto.Query

  schema "todos" do
    field :description, :string
    field :cost, :float
    belongs_to :user, AirApi.User, foreign_key: :owner_id

    timestamps
  end

  @required_fields ~w(description cost owner_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  #Order Todos by inserted date
  def ordered_by_date(query) do
    query
    |> order_by([t], desc: t.inserted_at)
  end
end
