defmodule DockupUi.GroupController do
    use DockupUi.Web, :controller
  
    alias DockupUi.Group
  
    def new(conn, _params) do
      changeset = Group.changeset(%Group{})
      render conn, "new.html", changeset: changeset
    end

    def create(conn, %{"group" => group_params}) do
      changeset = Group.changeset(%Group{}, group_params)
  
      case Repo.insert(changeset) do
        {:ok, _group} ->
          conn
          |> put_flash(:info, "Group created successfully.")
          |> redirect(to: config_path(conn, :index))
        {:error, changeset} ->
          render(conn, "new.html", changeset: changeset)
      end
    end

    def edit(conn, %{"id" => id}) do
      group = Repo.get!(Group, id)
      changeset = Group.changeset(group)
      render(conn, "edit.html", group: group, changeset: changeset)
    end

    def update(conn, %{"id" => id, "group" => group_params}) do
      group = Repo.get!(Group, id)
      changeset = Group.changeset(group, group_params)
  
      case Repo.update(changeset) do
        {:ok, _} ->
          conn
          |> put_flash(:info, "Group updated successfully.")
          |> redirect(to: config_path(conn, :index))
        {:error, changeset} ->
          render(conn, "edit.html", group: group, changeset: changeset)
      end
    end

    def delete(conn, %{"id" => id}) do
      group = Repo.get!(Group, id)
  
      Repo.delete!(group)
  
      conn
      |> put_flash(:info, "Group deleted successfully.")
      |> redirect(to: config_path(conn, :index))
    end
  end
  