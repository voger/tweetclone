defmodule TweetCloneWeb.Schema.UserTypes do
  use Absinthe.Schema.Notation
  use AbsintheAuth

  alias TweetCloneWeb.Resolvers.UserRelationships
  alias TweetCloneWeb.Policies.Reveal
  alias TweetClone.Accounts.User

  import Absinthe.Resolution.Helpers

  interface :user_interface do
    field :id, non_null(:integer)
    field :nickname, non_null(:string)
    field :subjects, list_of(:user)
    field :followers, list_of(:user)
    field :statuses, list_of(:status)

    resolve_type fn
      %User{id: id}, %{context: %{current_user: %{id: id}}} ->
        :me

      _, _ ->
        :user
    end
  end

  object :me do
    interfaces([:user_interface])
    field :id, non_null(:integer)
    field :nickname, non_null(:string)

    field :subjects, list_of(:user) do
      resolve dataloader(TweetClone.Repo)
    end

    field :statuses, list_of(:status) do
      resolve dataloader(TweetClone.Repo)
    end

    field :followers, list_of(:user) do
      resolve dataloader(TweetClone.Repo)
    end

    field :email, :string

    field :direct_messages, list_of(:status) do
      resolve dataloader(TweetClone.Repo)
    end
  end

  object :user do
    interfaces([:user_interface])
    field :id, non_null(:integer)
    field :nickname, non_null(:string)

    field :followers, list_of(:user) do
      resolve dataloader(TweetClone.Repo)
    end

    field :subjects, list_of(:user) do
      resolve dataloader(TweetClone.Repo)
    end

    field :statuses, list_of(:status) do
      resolve dataloader(TweetClone.Repo)
    end
  end

  input_object :follow_user_input do
    field :id, non_null(:integer)
  end

  object :follow_user_result do
    field :user, :user
    field :errors, list_of(:input_error)
  end
end
