defmodule AirApi.UserView do
  use AirApi.Web, :view

  def render("show.json", %{user: user, jwt: jwt, exp: exp}) do
    %{data: render_one(user, AirApi.UserView, "user.json"),
      session: %{token: jwt, exp: exp}
     }
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      email: user.email
    }
  end
end