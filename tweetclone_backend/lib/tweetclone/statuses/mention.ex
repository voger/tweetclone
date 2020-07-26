defmodule TweetClone.Statuses.Mention do
  use Ecto.Schema
  import Ecto.Changeset

  schema "mentions" do
    belongs_to :user, TweetClone.Accounts.User
    belongs_to :status, TweetClone.Statuses.Status

    timestamps()
  end

  def changeset(%__MODULE__{} = mention, %{user: user, status: status}) do
    mention
    |> change()
    |> put_assoc(:user, user)
    |> put_assoc(:status, status)
  end
end
