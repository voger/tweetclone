defmodule TweetCloneWeb.Schema.StatusTypes do
  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers

  import_types Absinthe.Type.Custom

  object :status do
    field :id, :integer
    field :text, :string

    field :sender, :user do
      resolve dataloader(TweetClone.Repo)
    end

    field :recipient, :user do
      resolve dataloader(TweetClone.Repo)
    end

    field :created_at, :date do
      middleware Absinthe.Middleware.MapGet, :inserted_at
    end
  end

  input_object :create_status_input do
    field :text, non_null(:string)
  end

  input_object :create_private_status_input do
    field :text, non_null(:string)
    field :recipient, non_null(:string)
  end

  input_object :get_status_input do
    field :id, non_null(:integer)
  end

  input_object :statuses_privacy do
    field :privacy, :privacy
  end

  object :create_status_result do
    field :status, :status
    field :errors, list_of(:input_error)
  end

  enum :privacy do
    value :public
    value :private
  end
end
