defmodule TweetClone.Repo.Migrations.CreateMentions do
  use Ecto.Migration

  def change do
    create table(:mentions) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :status_id, references(:statuses, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:mentions, [:user_id, :status_id])
  end
end
