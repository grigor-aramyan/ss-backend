defmodule StuffSwap.Store.Item do
  use Ecto.Schema
  import Ecto.Changeset
  alias StuffSwap.Store.Item


  schema "items" do
    field :description, :string
    field :picture_uri, :string
    field :title, :string
    field :category_id, :id
    field :subcategory_id, :id
    field :user_id, :id
    field :is_free, :boolean

    timestamps()
  end

  @doc false
  def changeset(%Item{} = item, attrs) do
    item
    |> cast(attrs, [:title, :description, :picture_uri, :is_free, :category_id, :subcategory_id, :user_id])
    |> validate_required([:title, :description, :picture_uri, :is_free, :category_id, :subcategory_id, :user_id])
  end
end
