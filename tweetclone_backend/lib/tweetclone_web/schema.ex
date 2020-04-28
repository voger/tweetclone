defmodule TweetCloneWeb.Schema do
  use Absinthe.Schema

  alias TweetCloneWeb.Resolvers
  import_types __MODULE__.UserTypes

  query do
    field :user, :user do
      arg :id, non_null(:string)
      resolve &Resolvers.User.get_user/3
    end
  end
end
