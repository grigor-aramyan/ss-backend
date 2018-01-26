defmodule StuffSwap.Repo.Migrations.CreateSubcategories do
  use Ecto.Migration

  def change do
    create table(:subcategories) do
      add :title, :string
      add :category_id, references(:categories, on_delete: :nothing)

      timestamps()
    end

    create index(:subcategories, [:category_id])
  end
end
