defmodule TweetCloneWeb.Resolvers.Statuses do
  alias TweetClone.Statuses

  def create_status(_, %{input: input}, %{context: %{current_user: current_user}}) do
    attrs = Map.put(input, :sender, current_user)

    with {:ok, status} <- Statuses.create_status(attrs) do
      {:ok, %{status: status}}
    end
  end

  def get_status(_, %{input: %{id: id}}, %{context: %{current_user: current_user}}) do
    {:ok, Statuses.get_status(id, current_user)}
  end
end
