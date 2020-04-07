defmodule TweetCloneWeb.Plug.SentToken do
  use Plug.Router
  alias Bamboo.SentEmail

  require Cl

  @moduledoc """
  A plug that exposes delivered token over a JSON API.

  Modelled after Bamboo.SentEmailApiPlug, but it 
  returns only one token and the recipient in json format.
  """

  plug :match
  plug :dispatch

  get "/" do
    data = %{}

    with %{"email" => to_address} <- conn.query_params,
         {:ok, email} <- find_email(to_address) do
      data = format_json_email(email)
      send_json(conn, :ok, data)
    else
      {:error, :not_found} ->
        send_json(conn, :not_found, data)

      _ ->
        send_json(conn, :bad_request, data)
    end
  end

  defp find_email(address) do
    address = String.upcase(address)

    email =
      SentEmail.all()
      |> Enum.find(nil, fn %{to: to} ->
        Enum.any?(to, fn {_, to_address} ->
          address == String.upcase(to_address)
        end)
      end)

    if email do
      {:ok, email}
    else
      {:error, :not_found}
    end
  end

  defp send_json(conn, status, data) do
    body = data |> Bamboo.json_library().encode!()

    conn
    |> Plug.Conn.put_resp_content_type("application/json")
    |> send_resp(status, body)
  end

  defp format_json_email(email) do
    email
    |> Map.take([:to, :html_body])
    |> Map.update(:to, nil, &format_json_email_addresses/1)
  end

  defp format_json_email_addresses(addresses) do
    Enum.map(addresses, &format_json_email_address/1)
  end

  defp format_json_email_address({_name, address}) do
    address
  end
end
