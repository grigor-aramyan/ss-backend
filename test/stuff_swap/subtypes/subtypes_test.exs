defmodule StuffSwap.SubtypesTest do
  use StuffSwap.DataCase

  alias StuffSwap.Subtypes

  describe "subcategories" do
    alias StuffSwap.Subtypes.Subcategory

    @valid_attrs %{title: "some title"}
    @update_attrs %{title: "some updated title"}
    @invalid_attrs %{title: nil}

    def subcategory_fixture(attrs \\ %{}) do
      {:ok, subcategory} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Subtypes.create_subcategory()

      subcategory
    end

    test "list_subcategories/0 returns all subcategories" do
      subcategory = subcategory_fixture()
      assert Subtypes.list_subcategories() == [subcategory]
    end

    test "get_subcategory!/1 returns the subcategory with given id" do
      subcategory = subcategory_fixture()
      assert Subtypes.get_subcategory!(subcategory.id) == subcategory
    end

    test "create_subcategory/1 with valid data creates a subcategory" do
      assert {:ok, %Subcategory{} = subcategory} = Subtypes.create_subcategory(@valid_attrs)
      assert subcategory.title == "some title"
    end

    test "create_subcategory/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Subtypes.create_subcategory(@invalid_attrs)
    end

    test "update_subcategory/2 with valid data updates the subcategory" do
      subcategory = subcategory_fixture()
      assert {:ok, subcategory} = Subtypes.update_subcategory(subcategory, @update_attrs)
      assert %Subcategory{} = subcategory
      assert subcategory.title == "some updated title"
    end

    test "update_subcategory/2 with invalid data returns error changeset" do
      subcategory = subcategory_fixture()
      assert {:error, %Ecto.Changeset{}} = Subtypes.update_subcategory(subcategory, @invalid_attrs)
      assert subcategory == Subtypes.get_subcategory!(subcategory.id)
    end

    test "delete_subcategory/1 deletes the subcategory" do
      subcategory = subcategory_fixture()
      assert {:ok, %Subcategory{}} = Subtypes.delete_subcategory(subcategory)
      assert_raise Ecto.NoResultsError, fn -> Subtypes.get_subcategory!(subcategory.id) end
    end

    test "change_subcategory/1 returns a subcategory changeset" do
      subcategory = subcategory_fixture()
      assert %Ecto.Changeset{} = Subtypes.change_subcategory(subcategory)
    end
  end
end
