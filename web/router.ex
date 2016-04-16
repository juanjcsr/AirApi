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
    resources "/todols", TodolController
  end

  #Other scopes may use custom stacks.
  scope "/api", AirApi do
    pipe_through :api
    resources "/todos", TodoController
  end
end
