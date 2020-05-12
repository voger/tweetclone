defmodule TweetCloneWeb.Resolvers.Statuses do
  alias TweetClone.Statuses

  def create_status(_, %{input: %{text: text}}, %{context: %{current_user: current_user}}) do
    attrs = %{
      text: text,
      sender: current_user
    }

    Statuses.create_status(attrs)
  end

  def get_status(_, %{input: %{id: id}}, _) do
    {:ok, Statuses.get_status!(id)}
  end
end
