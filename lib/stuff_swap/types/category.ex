defmodule StuffSwap.Types.Category do
  use Ecto.Schema
  import Ecto.Changeset
  alias StuffSwap.Types.Category
  alias StuffSwap.Subtypes.Subcategory
  alias StuffSwap.Store.Item


  schema "categories" do
    field :title, :string

    has_many :subcategories, Subcategory
    has_many :items, Item

    timestamps()
  end

  @doc false
  def changeset(%Category{} = category, attrs) do
    category
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
