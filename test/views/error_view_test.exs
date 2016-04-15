defmodule AirApi.ErrorViewTest do
  use AirApi.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.html" do
    assert render_to_string(AirApi.ErrorView, "404.html", []) ==
           "Page not found"
  end

  test "render 500.html" do
    assert render_to_string(AirApi.ErrorView, "500.html", []) ==
           "Server internal error"
  end

  test "render any other" do
    assert render_to_string(AirApi.ErrorView, "505.html", []) ==
           "Server internal error"
  end

  test "render 404.json" do
    assert render(AirApi.ErrorView, "404.json", []) ==
          %{errors: %{detail: "not found"}}
  end

  test "render 500.json" do
    assert render(AirApi.ErrorView, "500.json", []) ==
          %{errors: %{detail: "internal server error"}}
  end

end
