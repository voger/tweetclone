# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :tweetclone,
  namespace: TweetClone,
  ecto_repos: [TweetClone.Repo, Terminator.Repo]

# Configures the endpoint
config :tweetclone, TweetCloneWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "zWRcPHhE1WEHTwC2Bhg+4OXWtm7Di98uzeaktraIIHrcxruo0qBKl/LxqKOEklrm",
  render_errors: [view: TweetCloneWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: TweetClone.PubSub, adapter: Phoenix.PubSub.PG2]

# Phauxth authentication configuration
config :phauxth,
  user_context: TweetClone.Accounts,
  crypto_module: Argon2,
  token_module: TweetCloneWeb.Auth.Token

# Mailer configuration
config :tweetclone, TweetCloneWeb.Mailer,
  adapter: Bamboo.LocalAdapter

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
