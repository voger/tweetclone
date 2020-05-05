defmodule TweetClone.UserRelationships.UserRelationship do
  use Ecto.Schema
  import Ecto.Changeset

  alias TweetClone.Accounts.User

  @primary_key false
  schema "user_relationships" do
    belongs_to :follower, User, foreign_key: :follower_id, primary_key: true
    belongs_to :subject, User, foreign_key: :subject_id, primary_key: true

    timestamps()
  end

  @doc false
  def changeset(user_relationship, %{subject: subject, follower: follower}) do
    user_relationship
    |> change
    |> put_assoc(:subject, subject)
    |> put_assoc(:follower, follower)
    |> validate_required([:subject, :follower])
    |> validate_different_users()
    |> unique_constraint([:subject, :follower],
      name: :user_relationships_subject_id_follower_id_index,
      message: "already following"
    )
  end

  defp validate_different_users(changeset) do
    validate_change(changeset, :subject, fn :subject, _subject ->
      with %{id: subject_id} <- fetch_field!(changeset, :subject),
           %{id: ^subject_id} <- fetch_field!(changeset, :follower) do
        [subject: "subject and follower can not be the same"]
      else
        _ ->
          []
      end
    end)
  end
end
