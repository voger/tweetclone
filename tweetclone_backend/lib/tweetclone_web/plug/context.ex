defmodule TweetCloneWeb.Plug.Context do
  @behaviour Plug

  def init(opts), do: opts

  def call(conn, _) do
    unless get_in(conn.private, [:absinthe, :context, :current_user]) do
      context = build_context(conn)
      Absinthe.Plug.put_options(conn, context: context)
    else
      conn
    end
  end

  defp build_context(%{assigns: %{current_user: current_user}}) do
    %{current_user: current_user}
  end

  defp build_context(_) do
    %{}
  end
end
