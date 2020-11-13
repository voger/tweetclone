defmodule TweetClone.Taggable.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tags" do
    field :name, :string

    has_many :taggings, TweetClone.Taggable.Tagging
    has_many :statuses, through: [:taggings, :status]

    timestamps()
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  @doc """
  Helper function to extract hashtags from text
  """
  def parse(text) do
    Regex.scan(~r/#[\w-]+/u, text)
    |> List.flatten()
  end
end
