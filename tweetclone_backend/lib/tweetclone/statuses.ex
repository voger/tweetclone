defmodule TweetClone.Statuses do
  @moduledoc """
  The Statuses context.
  """

  import Ecto.Query, warn: false

  alias TweetClone.Repo
  alias TweetClone.Statuses.Status
  alias TweetClone.Accounts.User
  alias TweetClone.Taggable.Tag

  require Cl

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

  def create_status_with_tags(attrs) do
    Ecto.Multi.new()
    |> Ecto.Multi.run(:tags, fn _, changes ->
      insert_and_get_all_tags(changes, attrs)
    end)
    |> Ecto.Multi.run(:status, fn _, changes ->
      insert_status(changes, attrs)
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{status: status}} ->
        {:ok, status}

      {:error, :status, changeset, _} ->
        {:error, changeset}
    end
  end

  defp insert_and_get_all_tags(_changes, attrs) do
    case Tag.parse(attrs.text) do
      [] ->
        {:ok, []}

      tags ->
        now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

        tag_maps = Enum.map(tags, &%{name: &1, inserted_at: now, updated_at: now})

        {_, tags} =
          Repo.insert_all(Tag, tag_maps,
            on_conflict: {:replace, [:updated_at]},
            returning: true,
            conflict_target: :name
          )
        {:ok, tags}
    end
  end

  defp insert_status(%{tags: tags}, attrs) do
    %Status{}
    |> Status.changeset(attrs, tags)
    |> Repo.insert_or_update()
  end

  def list_statuses(filters, user) do
    Enum.reduce(filters, Status, fn
      {_, nil}, query ->
        query

      {:tag, tag}, query ->
        from s in query,
          join: t in assoc(s, :tags),
          where: t.name == ^tag

      {:privacy, :public}, query ->
        from s in query, where: is_nil(s.recipient_id)

      {:privacy, :private}, query ->
        if user do
          from s in query, where: s.recipient_id == ^user.id
        else
          from s in query, where: false
        end
    end)
    |> Repo.all()
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
end
