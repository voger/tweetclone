defmodule TweetCloneWeb.Resolvers.Tags do
  alias TweetClone.Taggable

  def list_tags(_, _, _) do
    {:ok, Taggable.list_tags()}
  end
end
