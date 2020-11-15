defmodule TweetCloneWeb.Schema.TagTypes do
  use Absinthe.Schema.Notation

  object :tag do
    field :id, :integer
    field :name, :string
  end
end
