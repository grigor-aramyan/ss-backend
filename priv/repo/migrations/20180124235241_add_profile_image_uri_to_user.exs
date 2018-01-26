defmodule StuffSwap.Repo.Migrations.AddProfileImageUriToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :profile_image_uri, :string
    end
  end
end
