defmodule TweetCloneWeb.Schema do
  use Absinthe.Schema

  query do
    field :test, :string do
      resolve fn _, _, _ ->
        {:ok, "It works"}
      end
    end
  end
end
