defmodule StuffSwap.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :body, :string
      add :is_red, :boolean, default: false, null: false
      add :author_id, references(:users, on_delete: :nothing)
      add :addressedto_id, references(:users, on_delete: :nothing)
      add :item_id, references(:items, on_delete: :nothing)

      timestamps()
    end

    create index(:messages, [:author_id])
    create index(:messages, [:addressedto_id])
    create index(:messages, [:item_id])
  end
end
