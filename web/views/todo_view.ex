defmodule AirApi.TodoView do
  use AirApi.Web, :view

  def render("index.json", %{todos: todos}) do
    %{todos: render_many(todos, AirApi.TodoView, "todo.json")}
  end

  def render("show.json", %{todo: todo}) do
    %{todos: render_one(todo, AirApi.TodoView, "todo.json")}
  end

  def render("todo.json", %{todo: todo}) do
    %{id: todo.id,
      description: todo.description,
      cost: todo.cost
     }
  end
end
