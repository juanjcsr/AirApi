defmodule AirApi.TodoView do
  use AirApi.Web, :view

  def render("index.json", %{todos: todos}) do
    %{data: render_many(todos, AirApi.TodoView, "todo.json")}
  end

  def render("show.json", %{todo: todo}) do
    %{data: render_one(todo, AirApi.TodoView, "todo.json")}
  end

  def render("todo.json", %{todo: todo}) do
    %{id: todo.id,
      description: todo.description}
  end
end
