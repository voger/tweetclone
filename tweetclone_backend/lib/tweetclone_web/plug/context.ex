defmodule TweetCloneWeb.Plug.Context do
  @behaviour Plug
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    IO.inspect(context: context)
    Absinthe.Plug.put_options(conn, context: context)
  end

  defp build_context(%{assigns: %{current_user: current_user}}) do
    %{current_user: current_user}
  end

  defp build_context(_) do
    %{}
  end
end
