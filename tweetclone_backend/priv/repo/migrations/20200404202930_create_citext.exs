defmodule TweetClone.Repo.Migrations.CreateCitext do
  use Ecto.Migration

  def change do
    execute("CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public")
  end
end
