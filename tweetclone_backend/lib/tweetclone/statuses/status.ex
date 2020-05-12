defmodule TweetClone.Statuses.Status do
  use Ecto.Schema
  import Ecto.Changeset

  alias TweetClone.Accounts.User

  schema "statuses" do
    field :text, :string
    belongs_to :sender, User
    belongs_to :recipient, User

    timestamps()
  end

  @doc false
  def changeset(status, attrs) do
    status
    |> cast(attrs, [:text])
    |> put_assoc(:sender, attrs.sender)
    |> put_assoc(:recipient, Map.get(attrs, :recipient, nil))
    |> assoc_constraint(:sender)
    |> validate_required([:text, :sender])
  end
end
