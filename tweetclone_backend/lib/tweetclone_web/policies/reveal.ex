defmodule TweetCloneWeb.Policies.Reveal do
  use AbsintheAuth.Policy

  # def is_me(%{context: %{current_user: %{id: id}}, source: %{id: id}} = resolution, _, _) do
  #   allow!(resolution)
  # end

  # def is_me(resolution, _, _), do: deny!(resolution)
  # def is_me(resolution, _), do: deny!(resolution)
end
