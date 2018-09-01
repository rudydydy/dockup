defmodule DockupUi.API.LogView do
  use DockupUi.Web, :view

  def render("show.json", %{logs: logs}) do
    %{data: render_many(logs, DockupUi.API.LogView, "log.json")}
  end

  def render("log.json", %{log: log}) do
    %{
      timestamp: log["timestamp"],
      log: log["log"],
      sort: log["sort"]
    }
  end
end
