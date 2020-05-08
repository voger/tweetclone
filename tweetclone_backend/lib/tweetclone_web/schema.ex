defmodule TweetCloneWeb.Schema do
  use Absinthe.Schema

  alias TweetCloneWeb.Resolvers.Accounts
  alias TweetCloneWeb.Resolvers.UserRelationships

  alias __MODULE__.Middleware

  import_types __MODULE__.UserTypes

  query do
    field :me, :user do
      resolve &Accounts.me/3
    end

    field :user, :user do
      resolve &Accounts.get_user/3
      arg :id, non_null(:string)
    end
  end

  mutation do
    field :follow_user, :follow_user_result do
      arg :input, non_null(:follow_user_input)
      resolve &UserRelationships.create_user_relationship/3
    end

    field :unfollow_user, :follow_user_result do
      arg :input, non_null(:follow_user_input)
      resolve &UserRelationships.delete_user_relationship/3
    end
  end

  @desc "An error encountered trying to persist input"
  object :input_error do
    field :key, non_null(:string)
    field :message, non_null(:string)
  end

  def middleware(middleware, _field, %{identifier: :mutation}) do
    middleware ++ [Middleware.ChangesetErrors]
  end

  def middleware(middleware, _field, _object) do
    middleware
  end
end
