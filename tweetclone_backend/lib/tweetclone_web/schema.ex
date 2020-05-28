defmodule TweetCloneWeb.Schema do
  use Absinthe.Schema

  alias TweetCloneWeb.Resolvers.Accounts
  alias TweetCloneWeb.Resolvers.UserRelationships
  alias TweetCloneWeb.Resolvers.Statuses

  alias TweetClone.Repo

  alias __MODULE__.Middleware

  import_types __MODULE__.UserTypes
  import_types __MODULE__.StatusTypes

  query do
    field :me, :user_interface do
      resolve &Accounts.me/3
    end

    field :user, :user_interface do
      resolve &Accounts.get_user/3
      arg :id, non_null(:string)
    end

    field :status, :status do
      resolve &Statuses.get_status/3
      arg :input, non_null(:get_status_input)
    end

    field :statuses, list_of(:status) do
      arg :input, :statuses_privacy, default_value: %{privacy: :public}
      resolve &Statuses.list_statuses/3
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

    field :create_status, :create_status_result do
      arg :input, non_null(:create_status_input)
      resolve &Statuses.create_status/3
    end

    field :create_private_status, :create_status_result do
      arg :input, non_null(:create_private_status_input)
      resolve &Statuses.create_status/3
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

  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(Repo, Dataloader.Ecto.new(Repo))

    Map.put(ctx, :loader, loader)
  end

  def plugins() do
    [Absinthe.Middleware.Dataloader | Absinthe.Plugin.defaults()]
  end
end
