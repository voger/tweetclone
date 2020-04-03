defmodule TweetCloneWeb.ConfirmView do
  use TweetCloneWeb, :view

  def render("info.json", %{info: message}) do
    %{info: %{detail: message}}
  end
end
