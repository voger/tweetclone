defmodule TweetCloneWeb.Resolvers.Tags do
  alias TweetClone.Taggable

  def list_tags(_, args, _) do
    {:ok, Taggable.list_tags(args)}
  end
end
