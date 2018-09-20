defmodule DockupUi.WhitelistedUrl do
  use DockupUi.Web, :model

  alias DockupUi.Group

  schema "whitelisted_urls" do
    field :name, :string
    field :git_url, :string

    belongs_to :group, Group

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :git_url])
    |> validate_required([:name, :git_url])
    |> unique_constraint(:git_url)
  end
end
