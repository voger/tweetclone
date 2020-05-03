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
  Updates a user_relationship.

  ## Examples

      iex> update_user_relationship(user_relationship, %{field: new_value})
      {:ok, %UserRelationship{}}

      iex> update_user_relationship(user_relationship, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_relationship(%UserRelationship{} = user_relationship, attrs) do
    user_relationship
    |> UserRelationship.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user_relationship.

  ## Examples

      iex> delete_user_relationship(user_relationship)
      {:ok, %UserRelationship{}}

      iex> delete_user_relationship(user_relationship)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_relationship(%UserRelationship{} = user_relationship) do
    Repo.delete(user_relationship)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_relationship changes.

  ## Examples

      iex> change_user_relationship(user_relationship)
      %Ecto.Changeset{source: %UserRelationship{}}

  """
  def change_user_relationship(%UserRelationship{} = user_relationship) do
    UserRelationship.changeset(user_relationship, %{})
  end
end
