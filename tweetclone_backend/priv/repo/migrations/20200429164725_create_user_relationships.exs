defmodule TweetClone.Repo.Migrations.CreateUserRelationships do
  use Ecto.Migration

  def change do
    create table(:user_relationships, primary_key: false) do
      add :subject_id,
          references(:users,
            on_delete: :delete_all,
            on_update: :update_all,
            primary_key: true
          )

      add :follower_id,
          references(:users,
            on_delete: :delete_all,
            on_update: :update_all,
            primary_key: true
          )

      timestamps()
    end

    create unique_index(:user_relationships, [:subject_id, :follower_id])
  end
end
