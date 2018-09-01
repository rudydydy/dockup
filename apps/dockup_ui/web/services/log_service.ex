defmodule DockupUi.LogService do
  defp elasticsearch_url do
    Application.fetch_env!(:dockup_ui, :elasticsearch_url)
  end

  defp query_size do
    15
  end

  # TODO: Fix the query param on line number 15
  defp query_es(container_handle) do
    Elastix.Search.search(elasticsearch_url(), "", [""],
      %{"query" => %{
          "query_string" => %{
            "query" => ""
          }
      },
        "sort" => [
          %{"@timestamp" => %{"order" => "asc"}}
        ],
        "size" => query_size()
      }
    )
  end

  defp query_es(container_handle, search_after) do
    Elastix
    .Search
    .search(elasticsearch_url(), "", [""],
      %{"query" => %{
          "query_string" => %{
            "query" => ""
          }
      },
        "search_after" => [search_after],
        "sort" => [
          %{"@timestamp" => %{"order" => "asc"}}
        ],
        "size" => query_size()
      }
    )
  end

  def fetch_logs(container_handle, search_after) do
    case search_after do
      nil -> query_es(container_handle)
      _ -> query_es(container_handle, search_after)
    end
  end
end
