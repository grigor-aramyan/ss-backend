defmodule StuffSwap.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :title, :string
      add :description, :string
      add :picture_uri, :string
      add :category_id, references(:categories, on_delete: :nothing)
      add :subcategory_id, references(:subcategories, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:items, [:category_id])
    create index(:items, [:subcategory_id])
    create index(:items, [:user_id])
  end
end
