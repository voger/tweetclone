defmodule TweetClone.Statuses.Status do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias TweetClone.Accounts
  alias TweetClone.Accounts.User
  alias TweetClone.Repo
  alias TweetClone.Taggable

  schema "statuses" do
    field :text, :string
    belongs_to :sender, User
    belongs_to :recipient, User

    many_to_many :mentioned_users, User, join_through: TweetClone.Statuses.Mention
    many_to_many :tags, Taggable.Tag, join_through: Taggable.Tagging, on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(status, attrs, tags) do
    status
    |> cast(attrs, [:text])
    |> put_assoc(:sender, attrs.sender)
    |> put_assoc(:tags, tags)
    |> maybe_assoc_recipient(attrs)
    |> assoc_constraint(:sender)
    |> validate_required([:text, :sender])
    |> shorten_urls()
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

    mentioned_users = Repo.all(from(u in User, where: u.nickname in ^mentioned_nicknames))
    put_assoc(changeset, :mentioned_users, mentioned_users)
  end

  defp shorten_urls(changeset = %{valid?: true}) do
    text = get_change(changeset, :text, "")

    shotrened_urls =
      Regex.scan(~r/(http|https)\:\/\/[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(\/\S*)?/i, text,
        capture: :first
      )
      |> List.flatten()
      |> Task.async_stream(fn url ->
        with result <- TweetClone.Shorteners.Bitly.shorten(url) do
          Map.put(result, "text_url", url)
        end
      end)
      |> Enum.map(fn {:ok, result} -> result end)

    replaced_text = replace_urls_with_short(text, shotrened_urls)

    put_change(changeset, :text, replaced_text)
  end

  defp shorten_urls(changeset), do: changeset

  defp replace_urls_with_short(text, urls) do
    Enum.reduce(urls, text, fn %{"link" => link, "text_url" => text_url}, text ->
      String.replace(text, text_url, link)
    end)
  end
end
