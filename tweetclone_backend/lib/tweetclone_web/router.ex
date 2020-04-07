defmodule TweetCloneWeb.Router do
  use TweetCloneWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Phauxth.AuthenticateToken
  end

  scope "/api", TweetCloneWeb do
    pipe_through :api

    post "/sessions", SessionController, :create
    resources "/users", UserController, except: [:new, :edit]
    get "/confirms", ConfirmController, :index
    post "/password_resets", PasswordResetController, :create
    put("/password_resets/update", PasswordResetController, :update)
  end

  scope "/api" do
    pipe_through :api

    if Bamboo.LocalAdapter =
         Application.compile_env(:tweetclone, [TweetCloneWeb.Mailer, :adapter]) do
      # forward "/sentemails", Bamboo.SentEmailApiPlug
      forward "/sentemails", TweetCloneWeb.Plug.SentToken
    end
  end
end
