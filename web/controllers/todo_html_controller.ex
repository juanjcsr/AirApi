defmodule AirApi.TodoHtmlController do
  require IEx
  use AirApi.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__

  alias AirApi.Todo
  alias AirApi.User

  plug :scrub_params, "todo" when action in [:create, :update]
  plug :correct_user, "todo" when action in [:update, :show]

  def index(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    query = from t in Todo, where: t.owner_id == ^user.id
    todos = Repo.all(query)
    render(conn, "index.html", todos: todos)
  end

  def new(conn, _params) do
    changeset = Todo.changeset(%Todo{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"todo" => todo_params}) do
    user = Guardian.Plug.current_resource(conn)
    changeset = Todo.changeset(%Todo{owner_id: user.id}, todo_params)

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
    query = from t in Todo, where: t.owner_id == ^conn.assigns[:user_id] and t.id == ^id
    case Repo.one(query) do
      nil ->
        conn
        |> put_flash(:info, "Not found")
        |> redirect(to: todo_html_path(conn, :index))
      todo ->
        render(conn, "show.html", todo: todo)
    end


  end

  def edit(conn, %{"id" => id}) do
    todo = Repo.get!(Todo, id)
    changeset = Todo.changeset(todo)
    render(conn, "edit.html", todo: todo, changeset: changeset)
  end

  def update(conn, %{"id" => id, "todo" => todo_params}) do
    todo = Repo.get!(Todo, id)
    changeset = Todo.changeset(todo, todo_params)
    cond do
      conn.assigns[:user_id] == todo.owner_id ->
        case Repo.update(changeset) do
          {:ok, todo} ->
            conn
            |> put_flash(:info, "Todol updated successfully.")
            |> redirect(to: todo_html_path(conn, :show, todo))
          {:error, changeset} ->
            render(conn, "edit.html", todol: todo, changeset: changeset)
        end
      true ->
        conn
        |> put_flash(:info, "Forbidden")
        |> redirect(to: todo_html_path(conn, :index))
    end

  end

  def delete(conn, %{"id" => id}) do
    todo = Repo.get!(Todo, id)
    cond do
      conn.assigns[:user_id] == todo.owner_id ->
        # Here we use delete! (with a bang) because we expect
        # it to always work (and if it does not, it will raise).
        Repo.delete!(todo)
        conn
        |> put_flash(:info, "Todo deleted successfully.")
        |> redirect(to: todo_html_path(conn, :index))
      true ->
        conn
        |> put_flash(:info, "Forbidden")
        |> redirect(to: todo_html_path(conn, :index))
    end
  end


  # handle the case where no authenticated user
  # was found
  def unauthenticated(conn, params) do
    conn
    |> put_flash(:error, "Authentication required")
    |> redirect(to: login_path(conn, :sign_in))
  end

  defp correct_user(conn, params) do
    user = Guardian.Plug.current_resource(conn)
    assign(conn, :user_id, user.id)

  end

end