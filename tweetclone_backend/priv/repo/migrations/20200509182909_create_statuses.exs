defmodule TweetClone.Repo.Migrations.CreateStatuses do
  use Ecto.Migration

  def change do
    create table(:statuses) do
      add :text, :string, size: 160, null: false
      add :sender_id, references(:users, on_delete: :nothing), null: false
      add :recipient_id, references(:users, on_delete: :nothing), null: true

      timestamps()
    end

    create index(:statuses, [:sender_id])
    create index(:statuses, [:recipient_id])
  end
end
