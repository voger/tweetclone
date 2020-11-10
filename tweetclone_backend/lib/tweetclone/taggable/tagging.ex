defmodule TweetClone.Taggable.Tagging do
  use Ecto.Schema
  import Ecto.Changeset

  schema "taggings" do
    belongs_to  TweetClone.Taggable.Tag
    belongs_to TweetClone.Status.Status

    timestamps()
  end

  @doc false
  def changeset(tagging, attrs) do
    tagging
    |> cast(attrs, [])
    |> validate_required([])
     |> unique_constraint(:name, name: :taggings_tag_id_status_id_index)
  end
end
