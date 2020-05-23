defmodule TweetCloneWeb.Schema.Mutation.StatusTest do
  use TweetCloneWeb.ConnCase, async: true

  import TweetCloneWeb.AuthTestHelpers

  describe "authenticated in user" do
    setup do
      bob = add_user_confirmed("bob@example.com")
      alice = add_user_confirmed("alice@example.net")
      conn = Absinthe.Plug.put_options(build_conn(), context: %{current_user: bob})
      {:ok, conn: conn, bob: bob, alice: alice}
    end

    @query """
    mutation CreateStatus($input: CreateStatusInput!) {
      createStatus(input: $input) {
        status {
          sender {
            nickname
          }
          text
          createdAt
        }
        errors {
          key
          message
        }
      }
    }
    """
    @variables """
    {
      "input": {
        "text": "Hello, World"
      }
    }
    """
    test "can create a public status", %{conn: conn} do
      response = post(conn, "/graphql", query: @query, variables: @variables)

      assert %{
               "data" => %{
                 "createStatus" => %{
                   "errors" => null,
                   "status" => %{
                     "createdAt" => _,
                     "sender" => %{"nickname" => "bob"},
                     "text" => "Hello, World"
                   }
                 }
               }
             } = json_response(response, 200)
    end

    @query """
    mutation CreatePrivateStatus($input: CreatePrivateStatusInput!) {
      createPrivateStatus(input: $input) {
        status {
          sender {
            nickname
          }
          recipient {
            nickname
            email
          }
          text
          createdAt
        }
        errors {
          key
          message
        }
      }
    }
    """
    @variables """
    {
      "input": {
      "recipient": "alice",
        "text": "Hello, World"
      }
    }
    """
    test "can create a private status", %{conn: conn} do
      response = post(conn, "/graphql", query: @query, variables: @variables)

      assert %{
               "data" => %{
                 "createPrivateStatus" => %{
                   "errors" => nil,
                   "status" => %{
                     "createdAt" => _,
                     "recipient" => %{
                       "email" => nil,
                       "nickname" => "alice"
                     },
                     "sender" => %{
                       "nickname" => "bob"
                     },
                     "text" => "Hello, World"
                   }
                 }
               },
               "errors" => [
                 %{
                   "locations" => [
                     %{
                       "column" => 0,
                       "line" => 9
                     }
                   ],
                   "message" => "Denied",
                   "path" => [
                     "createPrivateStatus",
                     "status",
                     "recipient",
                     "email"
                   ]
                 }
               ]
             } = json_response(response, 200)
    end

    @query """
    mutation CreatePrivateStatus($input: CreatePrivateStatusInput!) {
      createPrivateStatus(input: $input) {
        status {
          sender {
            nickname
          }
          recipient {
            nickname
            email
          }
          text
          createdAt
        }
        errors {
          key
          message
        }
      }
    }
    """
    @variables """
    {
      "input": {
      "recipient": "nobody",
      "text": "Hello, World"
      }
    }
    """
    test "can not create a private status to nonexistent recipient", %{conn: conn} do
      response = post(conn, "/graphql", query: @query, variables: @variables)

      %{
        "data" => %{
          "createPrivateStatus" => %{
            "errors" => [
              %{
                "key" => "recipient",
                "message" => "the user with nickname nobody does not exist"
              }
            ],
            "status" => nil
          }
        }
      } = json_response(response, 200)
    end
  end

  describe "anonymous user" do
    setup do
      add_user_confirmed("alice@example.net")
      {:ok, conn: build_conn()}
    end

    @query """
    mutation CreatePrivateStatus($input: CreatePrivateStatusInput!) {
      createPrivateStatus(input: $input) {
        status {
          sender {
            nickname
          }
          recipient {
            nickname
            email
          }
          text
          createdAt
        }
        errors {
          key
          message
        }
      }
    }
    """
    @variables """
    {
      "input": {
        "recipient": "alice",
        "text": "Hello, World"
      }
    }
    """
    test "cannot create a private status via the API", %{conn: conn} do
      response = post(conn, "/graphql", query: @query, variables: @variables)

      assert %{
               "data" => %{
                 "createPrivateStatus" => %{
                   "errors" => [
                     %{
                       "key" => "sender",
                       "message" => "can't be blank"
                     }
                   ],
                   "status" => nil
                 }
               }
             } = json_response(response, 200)
    end

    @query """
    mutation CreateStatus($input: CreateStatusInput!) {
      createStatus(input: $input) {
        status {
          sender {
            nickname
          }
          recipient {
            nickname
            email
          }
          text
          createdAt
        }
        errors {
          key
          message
        }
      }
    }
    """
    @variables """
    {
      "input": {
        "text": "D alice Hello, World"
      }
    }
    """
    test "cannot create a private status via direct message", %{conn: conn} do
      response = post(conn, "/graphql", query: @query, variables: @variables)

      assert %{
               "data" => %{
                 "createStatus" => %{
                   "errors" => [
                     %{
                       "key" => "sender",
                       "message" => "can't be blank"
                     }
                   ],
                   "status" => nil
                 }
               }
             } = json_response(response, 200)
    end

    @query """
    mutation CreateStatus($input: CreateStatusInput!) {
      createStatus(input: $input) {
        status {
          sender {
            nickname
          }
          recipient {
            nickname
            email
          }
          text
          createdAt
        }
        errors {
          key
          message
        }
      }
    }
    """
    @variables """
    {
      "input": {
        "text": "Hello, World"
      }
    }
    """
    test "cannot create a public status via the API", %{conn: conn} do
      response = post(conn, "/graphql", query: @query, variables: @variables)

      assert %{
               "data" => %{
                 "createStatus" => %{
                   "errors" => [
                     %{
                       "key" => "sender",
                       "message" => "can't be blank"
                     }
                   ],
                   "status" => nil
                 }
               }
             } = json_response(response, 200)
    end
  end
end
