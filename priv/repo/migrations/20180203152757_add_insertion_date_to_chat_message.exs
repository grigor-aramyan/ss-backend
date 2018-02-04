defmodule StuffSwap.Repo.Migrations.AddInsertionDateToChatMessage do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :insertion_date, :string
    end
  end
end
