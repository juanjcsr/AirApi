defmodule AirApi.LoginController do
  use AirApi.Web, :controller

  alias AirApi.User

  plug :scrub_params, "user" when action in [:create, :update]

  def sign_in(conn, _params) do
    render(conn, "sign_in.html")
  end

  def sign_up(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "sign_up.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.registration_changeset(%User{}, user_params)
    IO.inspect changeset

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully registered")
        |> redirect(to: page_path(conn, :index))
      {:error, changeset} ->
        render(conn, "sign_up.html", changeset: changeset)
    end

  end


end