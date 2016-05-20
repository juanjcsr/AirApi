defmodule AirApi.TodoController do
  require IEx
  use AirApi.Web, :controller

  alias AirApi.Todo

  plug :scrub_params, "todo" when action in [:create, :update]
  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__

  #plug AirApi.Authentication

  def index(conn, _params) do

    user = Guardian.Plug.current_resource(conn)
    query = from t in Todo, where: t.owner_id == ^user.id
    todos = Repo.all(query)
    render(conn, "index.json", todos: todos)
    #IO.puts("TESTTT")
    #IO.inspect(_params)
    #user_id = conn.assigns.current_user.id
    #query = from t in Todo, where: t.owner_id == ^user_id
    #todos = Repo.all(query)

    #render(conn, "index.json", todos: todos)
  end

  def create(conn, %{"todo" => todo_params}) do
    user = Guardian.Plug.current_resource(conn)
    changeset = Todo.changeset(%Todo{}, todo_params)
    #changeset = Todo.changeset(
    #  %Todo{owner_id: conn.assigns.current_user.id}, todo_params
    #)
    case Repo.insert(changeset) do
      {:ok, todo} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", todo_path(conn, :show, todo))
        |> render("show.json", todo: todo)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(AirApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    todo = Repo.get!(Todo, id)
    render(conn, "show.json", todo: todo)
  end

  def update(conn, %{"id" => id, "todo" => todo_params}) do
    IEx.pry
    todo = Repo.get!(Todo, id)
    changeset = Todo.changeset(todo, todo_params)
    #if(todo.owner_id == conn.assigns)
    #IO.inspect(todo)
    #case Repo.update(changeset) do
    #  {:ok, todo} ->
    #    render(conn, "show.json", todo: todo)
    #  {:error, changeset} ->
    #    conn
    #    |> put_status(:unprocessable_entity)
    #    |> render(AirApi.ChangesetView, "error.json", changeset: changeset)
    #end
  end

  def delete(conn, %{"id" => id}) do
    todo = Repo.get!(Todo, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(todo)

    send_resp(conn, :no_content, "")
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_status(401)
    |> render AirApi.ErrorView, "unauthenticated.json", message: "Authentication required"
  end


  #defp authorize_user(conn, todo, _) do
  #  user = conn.current_user
  #  if ( user && todo.owner_id == )
  #end
end
