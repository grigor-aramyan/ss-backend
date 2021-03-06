defmodule StuffSwap.Subtypes.Subcategory do
  use Ecto.Schema
  import Ecto.Changeset
  alias StuffSwap.Subtypes.Subcategory
  alias StuffSwap.Store.Item

  schema "subcategories" do
    field :title, :string
    field :pic_uri, :string
    field :category_id, :id

    has_many :items, Item

    timestamps()
  end

  @doc false
  def changeset(%Subcategory{} = subcategory, attrs) do
    subcategory
    |> cast(attrs, [:title, :pic_uri, :category_id])
    |> validate_required([:title, :category_id])
  end
end
