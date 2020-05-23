defmodule TweetClone.Statuses do
  @moduledoc """
  The Statuses context.
  """

  import Ecto.Query, warn: false

  alias TweetClone.Repo
  alias TweetClone.Statuses.Status
  alias TweetClone.Accounts.User

  @doc """
  Gets a single status.
  """
  def get_status(status_id, user) do
    Status
    |> where([s], s.id == ^status_id)
    |> where(^public_or_related(user))
    |> Repo.one()
  end

  defp public_or_related(%User{id: user_id}) do
    dynamic([s], is_nil(s.recipient_id) or s.recipient_id == ^user_id or s.sender_id == ^user_id)
  end

  defp public_or_related(nil) do
    dynamic([s], is_nil(s.recipient_id))
  end

  def create_status(attrs \\ %{}) do
    %Status{}
    |> Status.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a status.

  ## Examples

      iex> update_status(status, %{field: new_value})
      {:ok, %Status{}}

      iex> update_status(status, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_status(%Status{} = status, attrs) do
    status
    |> Status.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a status.

  ## Examples

      iex> delete_status(status)
      {:ok, %Status{}}

      iex> delete_status(status)
      {:error, %Ecto.Changeset{}}

  """
  def delete_status(%Status{} = status) do
    Repo.delete(status)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking status changes.

  ## Examples

      iex> change_status(status)
      %Ecto.Changeset{source: %Status{}}

  """
  def change_status(%Status{} = status) do
    Status.changeset(status, %{})
  end
end
