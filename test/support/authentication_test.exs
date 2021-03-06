defmodule AirApi.AuthenticationTest do
  use AirApi.ConnCase

  alias AirApi.{Authentication, Repo, User, Session}

  @opts Authentication.init([])

  @valid_attrs %{email: "bar@baz.com", password: "s3cr3t", password_confirmation: "s3cr3t"}

  def put_auth_token_in_header(conn, token) do
    conn
    |> put_req_header("authorization",  "Token token=\"#{token}\"")
  end

  test "finds the user by token", %{conn: conn} do
    user = Repo.insert!(%User{})
    session = Repo.insert!(%Session{token: "123", user_id: user.id})

    conn = conn
    |> put_auth_token_in_header(session.token)
    |> Authentication.call(@opts)

    assert conn.assigns.current_user
  end

  test "invalid token", %{conn: conn} do
    conn = conn
    |> put_auth_token_in_header("foo")
    |> Authentication.call(@opts)

    assert conn.status == 401
    assert conn.halted
  end

  test "no token", %{conn: conn} do
    conn = Authentication.call(conn, @opts)
    assert conn.status == 401
    assert conn.halted
  end
end