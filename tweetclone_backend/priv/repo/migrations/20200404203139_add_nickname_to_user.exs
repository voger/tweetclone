defmodule TweetClone.Repo.Migrations.AddNicknameToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :nickname, :citext
    end

    create unique_index(:users, [:nickname])
  end
end
