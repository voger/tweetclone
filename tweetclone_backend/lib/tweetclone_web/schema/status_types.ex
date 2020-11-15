defmodule TweetCloneWeb.Schema.StatusTypes do
  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers

  import_types(Absinthe.Type.Custom)

  object :status do
    field(:id, :integer)
    field(:text, :string)

    field :sender, :user_interface do
      resolve(dataloader(TweetClone.Repo))
    end

    field :recipient, :user do
      resolve(dataloader(TweetClone.Repo))
    end

    field :created_at, :date do
      middleware(Absinthe.Middleware.MapGet, :inserted_at)
    end

    field :mentions, non_null(list_of(:user_interface)) do
      resolve(dataloader(TweetClone.Repo, :mentioned_users)) || []
    end
  end


  object :create_status_result do
    field(:status, :status)
    field(:errors, list_of(:input_error))
  end

  input_object :create_status_input do
    field(:text, non_null(:string))
  end

  input_object :create_private_status_input do
    field(:text, non_null(:string))
    field(:recipient, non_null(:string))
  end

  input_object :get_status_input do
    field(:id, non_null(:integer))
  end

  input_object :filters do
    field :privacy, :privacy do
      arg(:privacy_val, :string, default_value: :public)
    end
      field(:tag, :string)
  end

  enum :privacy do
    value(:public)
    value(:private)
  end
end
