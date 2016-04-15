defmodule AirApi.TodoHtmlController do
  use AirApi.Web, :controller

  alias AirApi.Todo

  plug :scrub_params, "todo" when action in [:create, :update]

  def index(conn, _params) do
    todos = Repo.all(Todo)
    render(conn, "index.html", todos: todos)
  end

end