defmodule DockupUi.Repo.Migrations.AddNameToWhitelistUrls do
  use Ecto.Migration

  def change do
    alter table(:whitelisted_urls) do
      add :name, :string
    end
  end
end
