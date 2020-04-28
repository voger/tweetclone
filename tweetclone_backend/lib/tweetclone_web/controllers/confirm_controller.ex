defmodule TweetCloneWeb.ConfirmController do
  use TweetCloneWeb, :controller

  import TweetCloneWeb.Authorize

  alias Phauxth.Confirm
  alias TweetClone.Accounts
  alias TweetCloneWeb.Email

  def index(conn, params) do
    case Confirm.verify(params) do
      {:ok, user} ->
        Accounts.confirm_user(user)
        Email.confirm_success(user.email)

        conn
        |> put_view(TweetCloneWeb.ConfirmView)
        |> render("info.json", %{info: "Your account has been confirmed"})

      {:error, message} ->
        require Cl
        Cl.inspect(message, label: "-cb Error message")
        error(conn, :unauthorized, 401)
    end
  end
end
