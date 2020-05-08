defmodule TweetClone.UserRelationships do
  @moduledoc """
  The UserRelationships context.
  """

  import Ecto.Query, warn: false
  alias TweetClone.Repo
  alias TweetClone.Accounts.User

  alias TweetClone.UserRelationships.UserRelationship

  def get_user_followers(%User{} = user) do
    user
    |> Repo.preload(:followers)
    |> Map.get(:followers)
  end

  def create_user_relationship(attrs) do
    %UserRelationship{}
    |> UserRelationship.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a user_relationship.
  """
  def delete_user_relationship(subject_id, follower_id) do
    UserRelationship
    |> Repo.load(%{subject_id: subject_id, follower_id: follower_id})
    |> Repo.delete(
      stale_error_field: :subject,
      stale_error_message: "relationship does not exist"
    )
    |> case do
      {:ok, user_relationship} ->
        {:ok, Repo.preload(user_relationship, :subject)}

      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
