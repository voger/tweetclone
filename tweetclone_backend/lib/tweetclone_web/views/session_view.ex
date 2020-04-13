defmodule TweetCloneWeb.SessionView do
  use TweetCloneWeb, :view

  def render("info.json", %{info: info}) do
    %{info: info}
  end

  def render("logout.json", %{info: info}) do
    %{info: info}
  end
end
