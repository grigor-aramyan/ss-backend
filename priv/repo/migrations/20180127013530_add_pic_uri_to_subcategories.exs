defmodule StuffSwap.Repo.Migrations.AddPicUriToSubcategories do
  use Ecto.Migration

  def change do
    alter table(:subcategories) do
      add :pic_uri, :string
    end
  end
end
