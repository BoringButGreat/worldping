defmodule Worldping.API.Fake do
  @api_host Application.get_env(:worldping, :api_host)
  @api_key Application.get_env(:worldping, :api_key)
  @headers ["Authorization": @api_key]
  @default "Test not implemented"

  defp priv(path) do
    priv =
      :code.priv_dir(:worldping)
      |> to_string
    priv <> "/mock" <> path
  end

  defp load(path) do
    with {:ok, content} <- File.read(priv(path)),
    do: Poison.decode(content)
  end

  def api_get("/endpoints"), do: load("/endpoints.json")
  def api_get("/monitors"), do: load("/monitors.json")
  def api_get("/monitor_types"), do: load("/monitor_types.json")

  def api_get("/endpoints", %{tag: tag}) do
    with {:ok, endpoints} <- api_get("/endpoints") do
      {
        :ok,
        Enum.filter(endpoints, &(tag in &1["tags"]))
      }
    end
  end

  def api_get("/monitors", %{endpoint_id: id}) do
    with {:ok, monitors} <- api_get("/monitors") do
      {
        :ok,
        Enum.filter(monitors, &(to_string(id) == to_string(&1["endpoint_id"])))
      }
    end
  end

  def api_post("/monitors", json), do: {:ok, json}

  def api_put("/endpoints", json), do: {:ok, json}

  def api_delete(url), do: {:ok, "TEST: delete #{url}"}
end
