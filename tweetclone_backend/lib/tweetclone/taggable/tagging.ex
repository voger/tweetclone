defmodule TweetClone.Taggable.Tagging do
  use Ecto.Schema
  import Ecto.Changeset

  schema "taggings" do
    belongs_to(:tag, TweetClone.Taggable.Tag)
    belongs_to(:status, TweetClone.Status.Status)

    timestamps()
  end

  @doc false
  def changeset(tagging, attrs) do
    tagging
    |> cast(attrs, [])
    |> unique_constraint(:name, name: :taggings_tag_id_status_id_index)
    |> cast_assoc(:tag)
  end
end
