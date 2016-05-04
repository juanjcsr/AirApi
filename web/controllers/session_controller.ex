defmodule AirApi.SessionController do
  use AirApi.Web, :controller

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  alias AirApi.User
  alias AirApi.Session

  plug :scrub_params, "user" when action in [:create_web_session]

  def create(conn, %{"user" => user_params}) do
    user = Repo.get_by(User, email: user_params["email"])
    cond do
      user && checkpw(user_params["password"], user.password_hash) ->
        session_changeset = Session.registration_changeset(%Session{}, %{user_id: user.id})
        {:ok, session} = Repo.insert(session_changeset)
        conn
        |> put_status(:created)
        |> render("show.json", session: session)
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
        |> put_session(:current_user, user)
        |> put_flash(:info, "You are signed in.")
        |> redirect(to: page_path(conn, :index))
      true ->
        dummy_checkpw
        conn
        |> put_flash(:error, 'Username or password are incorrect')
        |> redirect(to: login_path(conn, :sign_in))
    end
  end
end