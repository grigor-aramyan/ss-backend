defmodule StuffSwap.Chat.Message do
  use Ecto.Schema
  import Ecto.Changeset
  alias StuffSwap.Chat.Message


  schema "messages" do
    field :body, :string
    field :is_red, :boolean, default: false
    field :insertion_date, :string
    field :author_id, :id
    field :addressedto_id, :id
    field :item_id, :id

    timestamps()
  end

  @doc false
  def changeset(%Message{} = message, attrs) do
    message
    |> cast(attrs, [:body, :is_red, :insertion_date, :author_id, :addressedto_id, :item_id])
    |> validate_required([:body, :insertion_date, :author_id, :addressedto_id, :item_id])
  end
end
