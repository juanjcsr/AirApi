defmodule AirApi.TodoTest do
  use AirApi.ModelCase

  alias AirApi.Todo

  @valid_attrs %{description: "some content", cost: 123}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Todo.changeset(%Todo{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Todo.changeset(%Todo{}, @invalid_attrs)
    refute changeset.valid?
  end
end
