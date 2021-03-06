defmodule TweetCloneWeb.Schema.Query.StatusTest do
  use TweetCloneWeb.ConnCase, async: true

  alias TweetClone.Statuses

  import TweetCloneWeb.AuthTestHelpers

  setup do
    bob = add_user_confirmed("bob@example.com")
    alice = add_user_confirmed("alice@example.net")
    eve = add_user_confirmed("eve@example.net")

    {:ok, bob: bob, alice: alice, eve: eve}
  end

  describe "authenticated user" do
    @query """
    query GetStatus($input:GetStatusInput!) {
          status(input: $input) {
        text
        sender {
          nickname
        }
        recipient {
          nickname
        }
      }
    }
    """
    test "can read a public status", %{bob: bob, eve: eve} do
      {:ok, %{id: public_status_id}} =
        Statuses.create_status(%{text: "Hello, World", sender: bob})

      variables = %{
        "input" => %{
          "id" => public_status_id
        }
      }

      response =
        build_conn()
        |> Absinthe.Plug.put_options(context: %{current_user: eve})
        |> post("/graphql", query: @query, variables: variables)

      assert %{
               "data" => %{
                 "status" => %{
                   "recipient" => nil,
                   "sender" => %{
                     "nickname" => "bob"
                   },
                   "text" => "Hello, World"
                 }
               }
             } = json_response(response, 200)
    end

    @query """
    query GetPrivateStatus($input: GetStatusInput!) {
      status(input: $input) {
        sender {
          nickname
        }
        recipient {
          nickname
        }
        text
      }
    }
    """
    test "can read only own private status", %{bob: bob, alice: alice, eve: eve} do
      {:ok, %{id: status_id}} =
        Statuses.create_status(%{text: "Hello, World", sender: bob, recipient: alice.nickname})

      variables = %{"input" => %{"id" => status_id}}

      response =
        build_conn()
        |> Absinthe.Plug.put_options(context: %{current_user: alice})
        |> post("/graphql", query: @query, variables: variables)

      assert %{
               "data" => %{
                 "status" => %{
                   "recipient" => %{
                     "nickname" => "alice"
                   },
                   "sender" => %{
                     "nickname" => "bob"
                   },
                   "text" => "Hello, World"
                 }
               }
             } = json_response(response, 200)

      response =
        build_conn()
        |> Absinthe.Plug.put_options(context: %{current_user: bob})
        |> post("/graphql", query: @query, variables: variables)

      assert %{
               "data" => %{
                 "status" => %{
                   "recipient" => %{
                     "nickname" => "alice"
                   },
                   "sender" => %{
                     "nickname" => "bob"
                   },
                   "text" => "Hello, World"
                 }
               }
             } = json_response(response, 200)

      response =
        build_conn()
        |> Absinthe.Plug.put_options(context: %{current_user: eve})
        |> post("/graphql", query: @query, variables: variables)

      assert %{
               "data" => %{
                 "status" => nil
               }
             } = json_response(response, 200)
    end

    @query """
    query GetStatuses($input: StatusesPrivacy) {
      statuses(input: $input) {
        text
        recipient {
          nickname 
        nickname
        }
        sender {
          nickname
        }
      }
    }
    """
    test "can list public or private statuses as desired", %{bob: bob, alice: alice, eve: eve} do

      # public statuses by bob
      Enum.each(1..3, fn _ ->
        TweetClone.Statuses.create_status(%{text: "Hello, World", sender: bob})
      end)

      # Statuses private for alice
      Enum.each(1..2, fn _ ->
        TweetClone.Statuses.create_status(%{
          text: "Hello, World",
          sender: bob,
          recipient: alice.nickname
        })
      end)

      # Let's make some statuses for eve
      Enum.each(1..2, fn _ ->
        TweetClone.Statuses.create_status(%{
          text: "Hello, World",
          sender: bob,
          recipient: eve.nickname
        })
      end)

      variables = %{
        "input" => %{
          "privacy" => "PUBLIC"
        }
      }

      response =
        build_conn()
        |> Absinthe.Plug.put_options(context: %{current_user: alice})
        |> post("/graphql", query: @query, variables: variables)
        |> json_response(200)

      assert length(response["data"]["statuses"]) == 3
      assert Enum.all?(response["data"]["statuses"], &(&1["recipient"] == nil))

      variables = %{
        "input" => %{
          "privacy" => "PRIVATE"
        }
      }

      response =
        build_conn()
        |> Absinthe.Plug.put_options(context: %{current_user: alice})
        |> post("/graphql", query: @query, variables: variables)
        |> json_response(200)

      assert length(response["data"]["statuses"]) == 2
      assert Enum.all?(response["data"]["statuses"], &(&1["recipient"]["nickname"] == "alice"))
    end
  end

  describe "anonymous user" do
    @query """
    query GetStatus($input:GetStatusInput!) {
          status(input: $input) {
        text
        sender {
          nickname
        }
        recipient {
          nickname
        }
      }
    }
    """
    test "can read a public status", %{bob: bob} do
      {:ok, %{id: public_status_id}} =
        Statuses.create_status(%{text: "Hello, World", sender: bob})

      variables = %{
        "input" => %{
          "id" => public_status_id
        }
      }

      response = post(build_conn(), "/graphql", query: @query, variables: variables)

      assert %{
               "data" => %{
                 "status" => %{
                   "recipient" => nil,
                   "sender" => %{
                     "nickname" => "bob"
                   },
                   "text" => "Hello, World"
                 }
               }
             } = json_response(response, 200)
    end

    test "can't read a private status", %{bob: bob, alice: alice} do
      {:ok, %{id: status_id}} =
        Statuses.create_status(%{text: "Hello, World", sender: bob, recipient: alice.nickname})

      variables = %{"input" => %{"id" => status_id}}

      response = post(build_conn(), "/graphql", query: @query, variables: variables)

      assert %{
               "data" => %{
                 "status" => nil
               }
             } = json_response(response, 200)
    end

    @query """
    query GetStatuses($input: StatusesPrivacy) {
      statuses(input: $input) {
        text
        recipient {
          nickname 
        nickname
        }
        sender {
          nickname
        }
      }
    }
    """
    test "can list public statuses but not private statuses", %{bob: bob, alice: alice, eve: eve} do

      # public statuses by bob
      Enum.each(1..3, fn _ ->
        TweetClone.Statuses.create_status(%{text: "Hello, World", sender: bob})
      end)

      # Statuses private for alice
      Enum.each(1..2, fn _ ->
        TweetClone.Statuses.create_status(%{
          text: "Hello, World",
          sender: bob,
          recipient: alice.nickname
        })
      end)

      # Let's make some statuses for eve
      Enum.each(1..2, fn _ ->
        TweetClone.Statuses.create_status(%{
          text: "Hello, World",
          sender: bob,
          recipient: eve.nickname
        })
      end)

      variables = %{
        "input" => %{
          "privacy" => "PUBLIC"
        }
      }

      response =
        build_conn()
        |> post("/graphql", query: @query, variables: variables)
        |> json_response(200)

      assert length(response["data"]["statuses"]) == 3
      assert Enum.all?(response["data"]["statuses"], &(&1["recipient"] == nil))

      variables = %{
        "input" => %{
          "privacy" => "PRIVATE"
        }
      }

      response =
        build_conn()
        |> post("/graphql", query: @query, variables: variables)
        |> json_response(200)

      assert length(response["data"]["statuses"]) == 0
    end
  end
end
