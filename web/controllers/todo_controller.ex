defmodule AirApi.TodoController do
  require IEx
  use AirApi.Web, :controller

  alias AirApi.Todo

  plug :scrub_params, "todo" when action in [:create, :update]
  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__
  plug :correct_user when action in [:update, :show, :delete,:create]
  #plug AirApi.Authentication

  def index(conn, _params) do

    user = Guardian.Plug.current_resource(conn)
    query = from t in Todo, where: t.owner_id == ^user.id
    todos = Repo.all(query)
    render(conn, "index.json", todos: todos)
  end

  def create(conn, %{"todo" => todo_params}) do
    #user = Guardian.Plug.current_resource(conn)
    #changeset = Todo.changeset(%Todo{}, todo_params)
    changeset = Todo.changeset(
      %Todo{owner_id: conn.assigns.user_id}, todo_params
    )
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
    query = from t in Todo, where: t.owner_id == ^conn.assigns[:user_id] and t.id == ^id
    case Repo.one(query) do
      nil ->
        conn
        |> put_status(404)
        |> render(AirApi.ErrorView, "404.json")
      todo ->
        render(conn, "show.json", todo: todo)

    end
  end

  def update(conn, %{"id" => id, "todo" => todo_params}) do
    query = from t in Todo, where: t.owner_id == ^conn.assigns[:user_id] and t.id == ^id
    case Repo.one(query) do
      nil ->
        conn
        |> put_status(404)
        |> render(AirApi.ErrorView, "404.json")
      todo ->
        changeset = Todo.changeset(todo, todo_params)
        case Repo.update(changeset) do
         {:ok, todo} ->
           render(conn, "show.json", todo: todo)
         {:error, changeset} ->
           conn
           |> put_status(:unprocessable_entity)
           |> render(AirApi.ChangesetView, "error.json", changeset: changeset)
        end

    end
    #changeset = Todo.changeset(todo, todo_params)

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
    query = from t in Todo, where: t.owner_id == ^conn.assigns[:user_id] and t.id == ^id
    case Repo.one(query) do
       nil ->
        conn
        |> put_status(404)
        |> render(AirApi.ErrorView, "404.json")
      todo ->
        send_resp(conn, :no_content, "")
    end
    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_status(401)
    |> render AirApi.ErrorView, "unauthenticated.json", message: "Authentication required"
  end

  defp correct_user(conn, _) do
    user = Guardian.Plug.current_resource(conn)
    assign(conn, :user_id, user.id)
  end


  #defp authorize_user(conn, todo, _) do
  #  user = conn.current_user
  #  if ( user && todo.owner_id == )
  #end
end
