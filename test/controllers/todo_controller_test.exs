defmodule AirApi.TodoControllerTest do
  use AirApi.ConnCase

  alias AirApi.Todo
  alias AirApi.User
  alias AirApi.Session

  @valid_attrs %{description: "some content", cost: 123}
  @invalid_attrs %{}

  setup %{conn: conn} do
    user = create_user(%{name: "jezz"})
    session = create_session(user)

    conn = conn
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", "Token token=\"#{session.token}\"")
    {:ok, conn: conn, current_user: user}
    #{:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  def create_user(%{name: name}) do
    User.changeset(%User{}, %{email: "#{name}@example.com"}) |> Repo.insert!
  end

  def create_session(user) do
    Session.registration_changeset(%Session{user_id: user.id}, %{}) |> Repo.insert!
  end

  def create_todo(%{description: _description, cost: _cost, owner_id: _owner_id} = options) do
    Todo.changeset(%Todo{}, options) |> Repo.insert!
  end

  test "lists all entries on index", %{conn: conn, current_user: current_user} do
    #conn = get conn, todo_path(conn, :index)
    #assert json_response(conn, 200)["data"] == []
    create_todo(%{description: "some content", cost: 123, owner_id: current_user.id})

    another_user = create_user(%{name: "pepe"})
    create_todo(%{description: "otra onda", cost: 321, owner_id: another_user.id})

    conn = get conn, todo_path(conn, :index)

    assert Enum.count(json_response(conn, 200)["data"]) == 1
    assert %{"description" => "some content"} = hd(json_response(conn, 200)["data"])
  end

  test "shows chosen resource", %{conn: conn} do
    todo = Repo.insert! %Todo{}
    conn = get conn, todo_path(conn, :show, todo)
    assert json_response(conn, 200)["data"] == %{"id" => todo.id,
      "description" => todo.description,
      "cost" => todo.cost}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, todo_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, current_user: current_user} do
    #conn = post conn, todo_path(conn, :create), todo: @valid_attrs
    #assert json_response(conn, 201)["data"]["id"]
    #assert Repo.get_by(Todo, @valid_attrs)
    conn = post conn, todo_path(conn, :create), todo: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    todo = Repo.get_by(Todo, @valid_attrs)

    assert todo
    assert todo.owner_id == current_user.id
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, todo_path(conn, :create), todo: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, current_user: current_user} do
    todo = Repo.insert! %Todo{}
    conn = put conn, todo_path(conn, :update, todo), todo: @valid_attrs
    IO.inspect(conn)
    assert json_response(conn, 201)["data"]["id"]
    todo = Repo.get_by(Todo, @valid_attrs)
    assert todo
    assert todo.owner_id == current_user.id
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    todo = Repo.insert! %Todo{}
    conn = put conn, todo_path(conn, :update, todo), todo: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    todo = Repo.insert! %Todo{}
    conn = delete conn, todo_path(conn, :delete, todo)
    assert response(conn, 204)
    refute Repo.get(Todo, todo.id)
  end
end
