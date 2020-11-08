defmodule TweetClone.Shorteners.Bitly do
  require Logger

  @apikey Application.fetch_env!(:tweetclone, :bitly_api_key)
  @default_headers [
    {"Authorization", "Bearer #{@apikey}"},
    {"Accept", "application/json"},
    {"Content-Type", "application/json"}
  ]

  @shorten_url "https://api-ssl.bitly.com/v4/shorten"

  def shorten(long_url) do
    payload =
      %{
        group_guid: guid!(),
        long_url: long_url,
        domain: "bit.ly"
      }
      |> Jason.encode!()

    with {:ok, %{status_code: 200, body: body}} <-
           Mojito.post(@shorten_url, @default_headers, payload) do
      body
      |> Jason.decode!()
      |> Map.take(["link", "long_url"])
    else
      {_, error} ->
        log_error_and_raise!("Could not shorten the URL.", error)
    end
  end

  defp guid!() do
    Application.get_env(:tweetclone, :bitly_group_guid) || get_group_guid!()
  end

  defp get_group_guid! do
    with {:ok, %{status_code: 200, body: body}} <-
           Mojito.get("https://api-ssl.bitly.com/v4/groups", @default_headers),
         {:ok, response} <- Jason.decode(body, keys: :atoms),
         {:ok, groups} <- Map.fetch(response, :groups),
         {:ok, guid} <- Map.fetch(hd(groups), :guid) do
      Application.put_env(:tweetclone, :bitly_group_guid, guid)
      guid
    else
      {_, error} ->
        log_error_and_raise!("Could not get the Bitly guid.", error)
    end
  end

  defp log_error_and_raise!(message, error) do
    message = message <> " Reason " <> inspect(error)
    Logger.error(message)
    raise message
  end
end
