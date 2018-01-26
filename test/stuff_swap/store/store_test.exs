defmodule StuffSwap.StoreTest do
  use StuffSwap.DataCase

  alias StuffSwap.Store

  describe "items" do
    alias StuffSwap.Store.Item

    @valid_attrs %{description: "some description", picture_uri: "some picture_uri", title: "some title"}
    @update_attrs %{description: "some updated description", picture_uri: "some updated picture_uri", title: "some updated title"}
    @invalid_attrs %{description: nil, picture_uri: nil, title: nil}

    def item_fixture(attrs \\ %{}) do
      {:ok, item} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Store.create_item()

      item
    end

    test "list_items/0 returns all items" do
      item = item_fixture()
      assert Store.list_items() == [item]
    end

    test "get_item!/1 returns the item with given id" do
      item = item_fixture()
      assert Store.get_item!(item.id) == item
    end

    test "create_item/1 with valid data creates a item" do
      assert {:ok, %Item{} = item} = Store.create_item(@valid_attrs)
      assert item.description == "some description"
      assert item.picture_uri == "some picture_uri"
      assert item.title == "some title"
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Store.create_item(@invalid_attrs)
    end

    test "update_item/2 with valid data updates the item" do
      item = item_fixture()
      assert {:ok, item} = Store.update_item(item, @update_attrs)
      assert %Item{} = item
      assert item.description == "some updated description"
      assert item.picture_uri == "some updated picture_uri"
      assert item.title == "some updated title"
    end

    test "update_item/2 with invalid data returns error changeset" do
      item = item_fixture()
      assert {:error, %Ecto.Changeset{}} = Store.update_item(item, @invalid_attrs)
      assert item == Store.get_item!(item.id)
    end

    test "delete_item/1 deletes the item" do
      item = item_fixture()
      assert {:ok, %Item{}} = Store.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> Store.get_item!(item.id) end
    end

    test "change_item/1 returns a item changeset" do
      item = item_fixture()
      assert %Ecto.Changeset{} = Store.change_item(item)
    end
  end
end
