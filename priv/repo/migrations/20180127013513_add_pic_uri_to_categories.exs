defmodule StuffSwap.Repo.Migrations.AddPicUriToCategories do
  use Ecto.Migration

  def change do
    alter table(:categories) do
      add :pic_uri, :string
    end
  end
end
