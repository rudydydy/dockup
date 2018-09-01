defmodule DockupUi.API.LogController do
  use DockupUi.Web, :controller
  import Ecto.Query

  alias DockupUi.LogService

  def show(conn, %{"container_handle" => container_handle} = params) do
    {:ok, result} = LogService.fetch_logs(container_handle, params["p"])
    logs = parse_result(result)
    render conn, "show.json", logs: logs
  end

  defp parse_result(result) do
    %{body: body, headers: _, request_url: _, status_code: _} = result
    %{"_shards" => _shards, "hits" => hits} = body
    %{"hits" => list} = hits
    Enum.map list, fn item ->
      %{"timestamp" => item["_source"]["@timestamp"],
        "log" => item["_source"]["log"],
        "sort" => "#{inspect item["sort"]}"
      }
    end
  end
end
