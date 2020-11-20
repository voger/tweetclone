defmodule TweetClone.Taggable do
  @moduledoc """
  The Taggable context.
  """

  import Ecto.Query, warn: false
  alias TweetClone.Repo

  alias TweetClone.Taggable.Tag

  @doc """
  Returns the list of tags.

  ## Examples

      iex> list_tags()
      [%Tag{}, ...]

  """
  def list_tags(args) do
    args
    |> Enum.reduce(Tag, fn
      {:limit, limit}, query ->
        query |> limit(^limit)

      {:status, status}, query ->
        query |> order_by(^order_by_status(status))
    end)
    |> Repo.all()
  end

  defp order_by_status(:trending) do
    [desc: dynamic([p], p.updated_at)]
  end

  defp order_by_status(:latest) do
    [desc: dynamic([p], p.inserted_at)]
  end

  @doc """
  Gets a single tag.

  Raises `Ecto.NoResultsError` if the Tag does not exist.

  ## Examples

      iex> get_tag!(123)
      %Tag{}

      iex> get_tag!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tag!(id), do: Repo.get!(Tag, id)

  @doc """
  Deletes a tag.

  ## Examples

      iex> delete_tag(tag)
      {:ok, %Tag{}}

      iex> delete_tag(tag)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tag(%Tag{} = tag) do
    Repo.delete(tag)
  end
end
