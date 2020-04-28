defmodule TweetCloneWeb.Resolvers.Accounts do
  alias TweetClone.Accounts

  def get_user(_, %{id: id}, _) do
    with %Accounts.User{} = user <- Accounts.get_user!(id) do
      {:ok, user}
    # else
      # _ -> {:ok, nil}
    end
  end

  def me(_, _, %{context: %{current_user: current_user}}) do
    {:ok, current_user}
  end

  def me(_, _, _) do
    {:ok, nil}
  end
end
