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

  pipeline :browser_auth do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :api_auth do
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  scope "/", AirApi do
    pipe_through [:browser, :browser_auth] # Use the default browser stack

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
    post "/sign_in", SessionController, :create_web_session
    delete "/delete", SessionController, :logout
  end

  #Other scopes may use custom stacks.
  scope "/api", AirApi do
    pipe_through [:api, :api_auth]
    resources "/todos", TodoController
    resources "/users", UserController, only: [:create]
    resources "/sessions", SessionController, only: [:create]
    delete "/sessions/logout", SessionController, :logout_api
  end
end
