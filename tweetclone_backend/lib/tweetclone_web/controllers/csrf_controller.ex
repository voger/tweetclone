defmodule TweetCloneWeb.CSRFController do
  use TweetCloneWeb, :controller

  def show(conn, _) do
    csrf_token = Plug.CSRFProtection.get_csrf_token()

    conn
    |> fetch_session()
    |> put_session("_csrf_token", Process.get(:plug_unmasked_csrf_token))
    |> render("show.json", token: csrf_token)
  end
end
