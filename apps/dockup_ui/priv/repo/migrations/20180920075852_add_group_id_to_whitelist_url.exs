defmodule DockupUi.Repo.Migrations.AddGroupIdToWhitelistUrl do
  use Ecto.Migration

  def change do
    alter table(:whitelisted_urls) do
      add :group_id, references(:groups) 
    end
  end
end
