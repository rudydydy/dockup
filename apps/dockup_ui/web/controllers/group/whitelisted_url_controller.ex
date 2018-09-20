defmodule DockupUi.Group.WhitelistedUrlController do
  use DockupUi.Web, :controller

  alias DockupUi.{
    WhitelistedUrl,
    Group,
  }

  def new(conn, _params, group) do
    changeset = 
      group
      |> build_assoc(:whitelisted_urls)
      |> WhitelistedUrl.changeset(%{})

    render(conn, "new.html", group: group, changeset: changeset)
  end

  def create(conn, %{"whitelisted_url" => whitelisted_url_params}, group) do
    changeset = 
      group
      |> build_assoc(:whitelisted_urls)
      |> WhitelistedUrl.changeset(whitelisted_url_params)

    case Repo.insert(changeset) do
      {:ok, _whitelisted_url} ->
        conn
        |> put_flash(:info, "Whitelisted url created successfully.")
        |> redirect(to: config_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, params = %{"id" => id}, group) do
    whitelisted_url = 
      group
      |> assoc(:whitelisted_urls)
      |> Repo.get!(id)

    changeset = WhitelistedUrl.changeset(whitelisted_url)

    render(conn, "edit.html", group: group, whitelisted_url: whitelisted_url, changeset: changeset)
  end

  def update(conn, %{"id" => id, "whitelisted_url" => whitelisted_url_params}, group) do
    whitelisted_url = 
      group
      |> assoc(:whitelisted_urls)
      |> Repo.get!(id)

    changeset = WhitelistedUrl.changeset(whitelisted_url, whitelisted_url_params)

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Whitelisted url updated successfully.")
        |> redirect(to: config_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", whitelisted_url: whitelisted_url, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, group) do
    whitelisted_url = 
      group
      |> assoc(:whitelisted_urls)
      |> Repo.get!(id)

    Repo.delete!(whitelisted_url)

    conn
    |> put_flash(:info, "Whitelisted url deleted successfully.")
    |> redirect(to: config_path(conn, :index))
  end

  def action(conn = %{params: %{"group_id" => group_id}}, _) do
    group = Repo.get!(Group, group_id)
    apply(__MODULE__, action_name(conn), [conn, conn.params, group])
  end
end
  