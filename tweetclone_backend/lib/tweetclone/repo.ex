defmodule TweetClone.Repo do
  use Ecto.Repo,
    otp_app: :tweetclone,
    adapter: Ecto.Adapters.Postgres
end
