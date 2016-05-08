defmodule AirApi.TodoHtmlController do
  use AirApi.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__

  alias AirApi.Todo

  plug :scrub_params, "todo" when action in [:create, :update]

  def index(conn, _params) do
    todos = Repo.all(Todo)
    render(conn, "index.html", todos: todos)
  end

  def new(conn, _params) do
    changeset = Todo.changeset(%Todo{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"todo" => todo_params}) do
    changeset = Todo.changeset(%Todo{}, todo_params)

    case Repo.insert(changeset) do
      {:ok, _todol} ->
        conn
        |> put_flash(:info, "Todo created successfully.")
        |> redirect(to: todo_html_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    todo = Repo.get!(Todo, id)
    render(conn, "show.html", todo: todo)
  end

  def edit(conn, %{"id" => id}) do
    todo = Repo.get!(Todo, id)
    changeset = Todo.changeset(todo)
    render(conn, "edit.html", todo: todo, changeset: changeset)
  end

  def update(conn, %{"id" => id, "todo" => todo_params}) do
    todo = Repo.get!(Todo, id)
    changeset = Todo.changeset(todo, todo_params)

    case Repo.update(changeset) do
      {:ok, todo} ->
        conn
        |> put_flash(:info, "Todol updated successfully.")
        |> redirect(to: todo_html_path(conn, :show, todo))
      {:error, changeset} ->
        render(conn, "edit.html", todol: todo, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    todo = Repo.get!(Todo, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(todo)

    conn
    |> put_flash(:info, "Todo deleted successfully.")
    |> redirect(to: todo_html_path(conn, :index))
  end


  # handle the case where no authenticated user
  # was found
  def unauthenticated(conn, params) do
    conn
    |> put_flash(:error, "Authentication required")
    |> redirect(to: login_path(conn, :sign_in))
  end

end