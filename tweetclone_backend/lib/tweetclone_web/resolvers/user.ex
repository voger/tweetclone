defmodule TweetCloneWeb.Resolvers.User do
  alias TweetClone.Accounts

  def get_user(_, %{id: id}, _) do
    with %Accounts.User{} = user <- Accounts.get_user!(id) do
      {:ok, user}
    end
  end
end
