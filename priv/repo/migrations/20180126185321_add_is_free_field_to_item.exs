defmodule StuffSwap.Repo.Migrations.AddIsFreeFieldToItem do
  use Ecto.Migration

  def change do
    alter table(:items) do
      add :is_free, :boolean
    end
  end
end
