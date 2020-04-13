defmodule TweetCloneWeb.AuthView do
  use TweetCloneWeb, :view

  def render("401.json", _assigns) do
    %{errors: %{detail: "You need to login to view this resource"}}
  end

  def render("403.json", _assigns) do
    %{errors: %{detail: "You are not authorized to view this resource"}}
  end

  def render("bad_login.json", _assigns) do
    %{errors: %{detail: "Bad username or password"}}
  end

  def render("logged_in.json", _assigns) do
    %{errors: %{detail: "You are already logged in"}}
  end
end
