defmodule TweetCloneWeb.SessionController do
  use TweetCloneWeb, :controller

  import TweetCloneWeb.Authorize

  # import Plug.Conn, only: [get_session: 2]

  alias Phauxth.Remember
  alias TweetClone.Sessions
  alias TweetClone.Sessions.Session
  alias TweetCloneWeb.Auth.Login

  # the following plug is defined in the controllers/authorize.ex file
  plug :guest_check when action in [:create]
  plug :user_check when action in [:logout]

  plug :assign_session_id when action in [:logout]

  require Cl
  def create(conn, %{"session" => params}) do
    case Login.verify(params) do
      {:ok, user} ->
        # The Sessions.create_session function is only needed if you are tracking
        # sessions in the database. If you do not want to store session data in the
        # database, remove this line, the TweetClone.Sessions alias and the
        # TweetClone.Sessions and TweetClone.Sessions.Session modules
        {:ok, %{id: session_id}} = Sessions.create_session(%{user_id: user.id})

         delete_csrf_token()

        conn
        |> put_session(:phauxth_session_id, session_id)
        # |> put_resp_cookie("csrftoken", get_csrf_token(), http_only: false)
        # |> put_session("_csrf_token", Plug.CSRFProtection.get_csrf_token())
        |> configure_session(renew: true)
        |> render("info.json", %{info: :ok})

      {:error, _message} ->
        error(conn, :unauthorized, 401)
    end
  end

  def logout(
        %Plug.Conn{assigns: %{current_user: %{id: user_id}, session_id: session_id}} = conn,
        _
      ) do
    case Sessions.get_session(session_id) do
      %Session{user_id: ^user_id} = session ->
        Sessions.delete_session(session)

        conn
        |> delete_session(:phauxth_session_id)
        |> Remember.delete_rem_cookie()
        |> configure_session(drop: true)
        |> render("logout.json", info: :ok)

      _ ->
        error(conn, :unauthorized, 401)
    end
  end

  def assign_session_id(conn, _opts) do
    session_id = get_session(conn, :phauxth_session_id)
    assign(conn, :session_id, session_id)
  end
end
