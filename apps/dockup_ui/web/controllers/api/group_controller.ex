defmodule DockupUi.API.GroupController do
  use DockupUi.Web, :controller
  import Ecto.Query

  alias DockupUi.{
    Group,
    Repo
  }

  def index(conn, _params) do
    query = from(
      g in Group,
      order_by: [asc: g.title],
      limit: 100,
      preload: [:whitelisted_urls]
    )

    groups = Repo.all(query)
    
    conn
    |> put_status(:ok)
    |> render("index.json", groups: groups)
  end
end