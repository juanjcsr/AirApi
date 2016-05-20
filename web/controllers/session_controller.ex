defmodule AirApi.SessionController do
  use AirApi.Web, :controller

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  alias AirApi.User
  alias AirApi.Session

  plug :scrub_params, "user" when action in [:create_web_session]

  def create(conn, %{"user" => user_params}) do
    user = Repo.get_by(User, email: user_params["email"])
    IO.inspect(user)
    cond do
      user && checkpw(user_params["password"], user.password_hash) ->
        #session_changeset = Session.registration_changeset(%Session{}, %{user_id: user.id})
        #{:ok, session} = Repo.insert(session_changeset)
        new_conn = Guardian.Plug.api_sign_in(conn, user)
        jwt = Guardian.Plug.current_token(new_conn)
        {:ok, claims} = Guardian.Plug.claims(new_conn)
        exp = Map.get(claims, "exp")
        new_conn
        |> put_status(:created)
        |> render("show.json", user: user, jwt: jwt, exp: exp)
      user ->
        conn
        |> put_status(:unauthorized)
        |> render("error.json", user_params)
      true ->
        dummy_checkpw
        conn
        |> put_status(:unauthorized)
        |> render("error.json", user_params)
    end
  end

  def create_web_session(conn, %{"user" => user_params}) do
    user = Repo.get_by(User, email: user_params["email"])
    IO.inspect(user)
    cond do
      user && checkpw(user_params["password"], user.password_hash) ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> put_session(:current_user, user)
        |> put_flash(:info, "You are signed in.")
        |> redirect(to: todo_html_path(conn, :index))
      true ->
        dummy_checkpw
        conn
        |> put_flash(:error, 'Username or password are incorrect')
        |> redirect(to: login_path(conn, :sign_in))
    end
  end

  def logout(conn, _params) do
    conn
    |> Guardian.Plug.sign_out
    |> put_flash(:info, "Logged out")
    |> redirect(to: "/")
  end

  #Logout via API
  def logout_api(conn, _params) do
    jwt = Guardian.Plug.current_token(conn)
    {:ok, claims} = Guardian.Plug.claims(conn)
    Guardian.revoke!(jwt, claims)
    conn
    |> render("logout.json", message: "logged out")
  end

  def current_user(conn) do
    user = Guardian.Plug.current_resource(conn)
    if user, do: user
  end

  def logged_in?(conn), do: !!current_user(conn)
end