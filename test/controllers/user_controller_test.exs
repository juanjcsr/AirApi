defmodule AirApi.UserControllerTest do
  use AirApi.ConnCase


  alias AirApi.User
  @valid_attrs %{email: "hola@test.com", password: "password", password_confirmation: "password"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "creates and render users when data is valid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @valid_attrs
    body = json_response(conn, 201)
    assert body["data"]["id"]
    assert body["data"]["email"]
    refute body["data"]["password"]
    assert Repo.get_by(User, email: "hola@test.com")
  end

  test "does not create resource and render errors when invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

end