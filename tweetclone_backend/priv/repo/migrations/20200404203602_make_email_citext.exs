defmodule TweetClone.Repo.Migrations.MakeEmailCitext do
  use Ecto.Migration

  def change do
    alter table(:users) do
      modify :email, :citext
    end
  end
end
