defmodule AirApi.Router do
  use AirApi.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AirApi do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/todos", TodoHtmlController, :index
    get "/todos/new", TodoHtmlController, :new
    post "/todos", TodoHtmlController, :create
    get "/todos/:id", TodoHtmlController, :show
    get "/todos/:id/edit", TodoHtmlController, :edit
    delete "/todos/:id", TodoHtmlController, :delete
    patch "/todos/:id", TodoHtmlController, :update
    put "/todos/:id", TodoHtmlController, :update

    get "/sign_up", LoginController, :sign_up
    post "/sign_up", LoginController, :create
    get "/sign_in", LoginController, :sign_in
  end

  #Other scopes may use custom stacks.
  scope "/api", AirApi do
    pipe_through :api
    resources "/todos", TodoController
    resources "/users", UserController, only: [:create]
  end
end
