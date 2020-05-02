defmodule TweetClone.UserRelationshipsTest do
  use TweetClone.DataCase

  alias TweetClone.UserRelationships

  describe "user_relationships" do
    alias TweetClone.UserRelationships.UserRelationship

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def user_relationship_fixture(attrs \\ %{}) do
      {:ok, user_relationship} =
        attrs
        |> Enum.into(@valid_attrs)
        |> UserRelationships.create_user_relationship()

      user_relationship
    end

    test "list_user_relationships/0 returns all user_relationships" do
      user_relationship = user_relationship_fixture()
      assert UserRelationships.list_user_relationships() == [user_relationship]
    end

    test "get_user_relationship!/1 returns the user_relationship with given id" do
      user_relationship = user_relationship_fixture()
      assert UserRelationships.get_user_relationship!(user_relationship.id) == user_relationship
    end

    test "create_user_relationship/1 with valid data creates a user_relationship" do
      assert {:ok, %UserRelationship{} = user_relationship} = UserRelationships.create_user_relationship(@valid_attrs)
    end

    test "create_user_relationship/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserRelationships.create_user_relationship(@invalid_attrs)
    end

    test "update_user_relationship/2 with valid data updates the user_relationship" do
      user_relationship = user_relationship_fixture()
      assert {:ok, %UserRelationship{} = user_relationship} = UserRelationships.update_user_relationship(user_relationship, @update_attrs)
    end

    test "update_user_relationship/2 with invalid data returns error changeset" do
      user_relationship = user_relationship_fixture()
      assert {:error, %Ecto.Changeset{}} = UserRelationships.update_user_relationship(user_relationship, @invalid_attrs)
      assert user_relationship == UserRelationships.get_user_relationship!(user_relationship.id)
    end

    test "delete_user_relationship/1 deletes the user_relationship" do
      user_relationship = user_relationship_fixture()
      assert {:ok, %UserRelationship{}} = UserRelationships.delete_user_relationship(user_relationship)
      assert_raise Ecto.NoResultsError, fn -> UserRelationships.get_user_relationship!(user_relationship.id) end
    end

    test "change_user_relationship/1 returns a user_relationship changeset" do
      user_relationship = user_relationship_fixture()
      assert %Ecto.Changeset{} = UserRelationships.change_user_relationship(user_relationship)
    end
  end
end
