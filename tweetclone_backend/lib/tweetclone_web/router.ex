defmodule TweetCloneWeb.Router do
  use TweetCloneWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :put_secure_browser_headers
    plug Phauxth.Authenticate
    plug TweetCloneWeb.Plug.Context
  end

  pipeline :protect_csrf do
    plug :protect_from_forgery
  end

  scope "/graphql" do
    pipe_through :api

    post "/", Absinthe.Plug, schema: TweetCloneWeb.Schema

    if Mix.env() == :dev do
      forward "/graphiql", Absinthe.Plug.GraphiQL,
        schema: TweetCloneWeb.Schema,
        interface: :advanced
    end
  end

  scope "/api", TweetCloneWeb do
    pipe_through :api
    pipe_through :protect_csrf

    resources "/users", UserController, except: [:create, :new, :edit]
    delete "/sessions", SessionController, :logout
    post "/password_resets", PasswordResetController, :create
    put "/password_resets/update", PasswordResetController, :update
  end

  scope "/api", TweetCloneWeb do
    pipe_through :api

    post "/sessions", SessionController, :create
    post "/users", UserController, :create
    post "/token", CSRFController, :show
    get "/confirms", ConfirmController, :index

    if Bamboo.LocalAdapter ==
         Application.compile_env(:tweetclone, [TweetCloneWeb.Mailer, :adapter]) do
      # forward "/sentemails", Bamboo.SentEmailApiPlug
      forward "/sentemails", Plug.SentToken
    end
  end
end
