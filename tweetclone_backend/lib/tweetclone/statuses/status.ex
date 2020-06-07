defmodule TweetClone.Statuses.Status do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias TweetClone.Accounts
  alias TweetClone.Accounts.User
  alias TweetClone.Repo

  schema "statuses" do
    field :text, :string
    belongs_to :sender, User
    belongs_to :recipient, User

    many_to_many :mentioned_users, User, join_through: TweetClone.Statuses.Mention

    timestamps()
  end

  @doc false
  def changeset(status, attrs) do
    status
    |> cast(attrs, [:text])
    |> put_assoc(:sender, attrs.sender)
    |> maybe_assoc_recipient(attrs)
    |> assoc_constraint(:sender)
    |> validate_required([:text, :sender])
    |> mention_users()
  end

  # If there is a recipient in the attrs map, then that is
  # used instead of the "D" task.
  # This whole function for parsing the user from a field or leading D
  # in the text is pointles and stupid. Our API should only have one 
  # way to do something. However we do it as an exercise.
  defp maybe_assoc_recipient(changeset, %{recipient: <<recipient_nickname::binary>>}) do
    if recipient = Accounts.get_by(%{"nickname" => recipient_nickname}) do
      put_assoc(changeset, :recipient, recipient)
    else
      add_error(
        changeset,
        :recipient,
        "the user with nickname %{recipient_nickname} does not exist",
        recipient_nickname: recipient_nickname
      )
    end
  end

  defp maybe_assoc_recipient(changeset, %{text: <<"D"::binary>> <> <<rest::binary>>} = attrs) do
    # create a pattern to allow some usual characters directly 
    # after the nickname
    pattern = :binary.compile_pattern([" ", "!", ",", ".", ":", "\n"])
    [recipient_nickname, text] = String.split(rest, pattern, parts: 2, trim: true)

    attrs =
      attrs
      |> Map.put(:text, text)
      |> Map.put(:recipient, recipient_nickname)

    changeset
    |> put_change(:text, text)
    |> maybe_assoc_recipient(%{attrs | text: text, recipient: recipient_nickname})
  end

  defp maybe_assoc_recipient(changeset, _) do
    changeset
  end

  defp mention_users(changeset) do
    text = get_change(changeset, :text, "")

    mentioned_nicknames =
      Regex.scan(~r/@[\w.@_-]+/u, text)
      |> Enum.map(fn nickname ->
        nickname
        |> hd()
        |> String.trim_leading("@")
      end)


    mentioned_users = Repo.all(from u in User, where: u.nickname in ^mentioned_nicknames)
    put_assoc(changeset, :mentioned_users, mentioned_users)
  end
end
