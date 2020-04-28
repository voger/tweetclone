defmodule TweetCloneWeb.Policies.Authorize do
  use AbsintheAuth.Policy

  def current_user(%{context: %{current_user: %TweetClone.Accounts.User{}}} = res, _, _) do
    allow!(res)
  end

  def current_user(res, _, _), do: deny!(res)
  def current_user(res, _), do: deny!(res)
end
