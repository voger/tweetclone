defmodule TweetCloneWeb.Resolvers.UserRelationships do
  alias TweetClone.Accounts
  alias TweetClone.Accounts.User
  alias TweetClone.UserRelationships

  def get_followers(%User{} = user, _, _) do
    {:ok, UserRelationships.get_user_followers(user)}
  end

  def create_user_relationship(_, %{input: %{id: subject_id}}, %{
        context: %{current_user: current_user}
      }) do
    subject = Accounts.get_user(subject_id)
    attrs = %{subject: subject, follower: current_user}

    case UserRelationships.create_user_relationship(attrs) do
      {:ok, %{subject: subject}} ->
        {:ok, %{user: subject}}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:error, changeset}
    end
  end

  def delete_user_relationship(_, %{input: %{id: subject_id}}, %{
        context: %{current_user: current_user}
      }) do
    case UserRelationships.delete_user_relationship(subject_id, current_user.id) do
      {:ok, %{subject: subject}} ->
        {:ok, %{user: subject}}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:error, changeset}
    end
  end
end
