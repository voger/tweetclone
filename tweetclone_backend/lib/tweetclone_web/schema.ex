defmodule TweetCloneWeb.Schema do
  use Absinthe.Schema

  alias TweetCloneWeb.Resolvers.Accounts

  import_types __MODULE__.UserTypes

  query do
    # import_fields :me

    field :me, :user do
      resolve &Accounts.me/3
    end

    field :user, :user do
      resolve &Accounts.get_user/3
      arg :id, non_null(:string)
    end
  end
end
