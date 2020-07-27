defmodule TweetClone.Shorteners.Bitly do
  use HTTPoison.Base

  @apikey Application.fetch_env!(:tweetclone, :bitly_api_key)
  @default_headers [
    Authorization: "Bearer #{@apikey}",
    Accept: "application/json",
    "Content-Type": "application/json"
  ]

  def shorten(long_url) do
    __MODULE__.start()
    __MODULE__.post("", long_url)
  end

  def process_request_headers(_) do
    @default_headers
  end

  def process_request_url(_) do
    "https://api-ssl.bitly.com/v4/shorten"
  end

  def process_request_body(body) do
    group_guid = Application.get_env(:tweetclone, :bitly_group_guid) || get_group_guid()

    #   %{
    #     # group_guid: ,
    #     domain: "bit.ly",
    #     long_url: body
    #   }
    #   |> Jason.encode()
    Jason.encode!(%{test: "ok"})
  end

  defp get_group_guid do
    IO.puts("getting guid")
    require Cl
    HTTPoison.start()

    with {:ok, %{status_code: 200, body: body}} <-
           HTTPoison.get("https://api-ssl.bitly.com/v4/groups", @default_headers),
         {:ok, response} <- Jason.decode(body, keys: :atoms),
         {:ok, groups} <- Map.fetch(response, :groups),
         {:ok, guid} <- Map.fetch(hd(groups), :guid) do
      Application.put_env(:tweetclone, :bitly_group_guid, guid)
      guid
    else
      result ->
        Cl.inspect(result, label: "-cb The wrong result")
    end
  end
end
