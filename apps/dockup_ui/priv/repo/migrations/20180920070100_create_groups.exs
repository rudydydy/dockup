defmodule DockupUi.Repo.Migrations.CreateGroups do
  use Ecto.Migration

  def change do
    create table(:groups) do
      add :title, :string

      timestamps()
    end

  end
end
