defmodule DockupUi.ConfigController do
  use DockupUi.Web, :controller

  alias DockupUi.{
    Group,
    WhitelistedUrl
  }

  import Ecto.Query

  def index(conn, _params) do
    query = from(
      g in Group,
      order_by: [asc: g.title],
      preload: [:whitelisted_urls]
    )

    groups = Repo.all(query)
      
    render(conn, "index.html", groups: groups)
  end
end
