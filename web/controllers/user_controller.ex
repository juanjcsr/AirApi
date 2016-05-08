defmodule AirApi.UserController do
  use AirApi.Web, :controller

  alias AirApi.User

  plug :scrub_params, "user" when action in [:create]

  def create(conn, %{"user" => user_params}) do
    changeset = User.registration_changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        new_conn = Guardian.Plug.api_sign_in(conn, user)
        jwt = Guardian.Plug.current_token(new_conn)
        {:ok, claims} = Guardian.Plug.claims(new_conn)
        exp = Map.get(claims, "exp")
        new_conn
        |> put_status(:created)
        |> render("show.json", user: user,jwt: jwt, exp: exp)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(AirApi.ChangesetView, "error.json", changeset: changeset)
    end

  end

end