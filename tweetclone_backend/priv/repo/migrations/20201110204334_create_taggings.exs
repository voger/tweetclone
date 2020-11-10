defmodule TweetClone.Repo.Migrations.CreateTaggings do
  use Ecto.Migration

  def change do
    create table(:taggings) do
      add :tag_id, references(:tags, on_delete: :delete_all)
      add :status_id, references(:statuses, on_delete: :delete_all)

      timestamps()
    end

    create index(:taggings, [:tag_id])
    create index(:taggings, [:status_id])
    create unique_index(:taggings, [:tag_id, :status_id])
  end
end
