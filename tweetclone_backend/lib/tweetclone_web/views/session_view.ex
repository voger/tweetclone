defmodule TweetCloneWeb.SessionView do
  use TweetCloneWeb, :view

  def render("info.json", %{info: token}) do
    %{access_token: token}
  end
end
