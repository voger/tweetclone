defmodule TweetCloneWeb.Schema.UserTypes do
  use Absinthe.Schema.Notation
  use AbsintheAuth

  alias TweetCloneWeb.Resolvers.UserRelationships
  alias TweetCloneWeb.Policies.Reveal

  object :user do
    field :nickname, non_null(:string)
    field :followers, list_of(:user) do
      resolve &UserRelationships.get_followers/3
    end
    field :email, :string do
      policy(Reveal, :is_me)
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
