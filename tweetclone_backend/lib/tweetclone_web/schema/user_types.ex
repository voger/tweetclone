defmodule TweetCloneWeb.Schema.UserTypes do
  use Absinthe.Schema.Notation
  use AbsintheAuth

  alias TweetCloneWeb.Resolvers.User
  alias TweetCloneWeb.Policies.Reveal

  object :user do
    field :nickname, :string

    field :email, :string do
      policy(Reveal, :is_me)
    end
  end
end
