defmodule TweetCloneWeb.Schema.StatusTypes do
  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers

  alias TweetClone.Statuses.Status
  import_types Absinthe.Type.Custom

  object :status do
    field :id, :integer
    field :text, non_null(:string)

    field :sender, :user do
      resolve dataloader(TweetClone.Repo)
    end

    field :receiver, list_of(:user) do
      resolve dataloader(TweetClone.Repo)
    end

    field :created_at, :date do
      middleware Absinthe.Middleware.MapGet, :inserted_at
    end
  end

  input_object :create_status_input do
    field :text, non_null(:string)
  end

  input_object :get_status_input do
    field :id, non_null(:id)
  end

  object :create_status_result do
    field :status, :status
    field :errors, list_of(:input_error)
  end
end
