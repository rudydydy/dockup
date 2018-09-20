defmodule DockupUi.API.GroupView do
  use DockupUi.Web, :view

  def render("index.json", %{groups: groups}) do
    %{data: render_many(groups, __MODULE__, "group.json")}
  end

  def render("group.json", %{group: group}) do
    %{
      id: group.id,
      title: group.title,
      whitelisted_urls: render_many(group.whitelisted_urls, __MODULE__, "whitelisted_url.json", as: :whitelisted_url)
    }
  end

  def render("whitelisted_url.json", %{whitelisted_url: whitelisted_url}) do
    %{
      id: whitelisted_url.id,
      name: whitelisted_url.name,
      git_url: whitelisted_url.git_url
    }
  end
end
  