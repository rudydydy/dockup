defmodule DockupUi.Group do
  use DockupUi.Web, :model

  alias DockupUi.WhitelistedUrl

  schema "groups" do
    field :title, :string

    has_many :whitelisted_urls, WhitelistedUrl, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(struct, attrs \\ %{}) do
    struct
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
