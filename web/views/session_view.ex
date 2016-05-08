defmodule AirApi.SessionView do
  use AirApi.Web, :view


  def render("show.json", %{user: user, jwt: jwt, exp: exp}) do
    %{user: %{email: user.email},
      session: %{token: jwt, exp: exp}
     }
  end


  def render("error.json", _anything ) do
    %{errors: "failed to authenticate"}
  end

end