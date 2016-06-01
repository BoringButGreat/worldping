defmodule Worldping do
  use Worldping.API

  @docmodule """
  Tools for getting data from the Worldping API

  Each Worldping API query accesses a different URL, not just different query
  arguments, so for clarity each type of Worldping API call gets its own
  function
  """

  @doc """
  Call the monitors query for ALL endpoints

      iex> {:ok, monitors} = Worldping.monitors
      ...> hd(monitors)["endpoint_id"]
      4626

      iex> {:ok, monitors} = Worldping.monitors
      ...> Map.keys(hd(monitors))
      ["collector_ids", "collector_tags", "collectors", "enabled", "endpoint_id",
       "endpoint_slug", "frequency", "health_settings", "id", "monitor_type_id",
       "monitor_type_name", "offset", "org_id", "settings", "state",
       "state_change", "state_check", "updated"]
  """
  def monitors, do: api_get "/monitors"

  @doc """
  Call the monitors query for a specific endpoint

      iex> {:ok, monitors} = Worldping.monitors(4626)
      ...> Map.keys(hd(monitors))
      ["collector_ids", "collector_tags", "collectors", "enabled", "endpoint_id",
       "endpoint_slug", "frequency", "health_settings", "id", "monitor_type_id",
       "monitor_type_name", "offset", "org_id", "settings", "state",
       "state_change", "state_check", "updated"]
  """
  def monitors(endpoint), do: api_get "/monitors", %{endpoint_id: endpoint}

  @doc """
  Get a list of monitor types

      iex> {:ok, types} = Worldping.monitor_types
      ...> Enum.map(types, fn(type) -> type["name"] end)
      ["DNS", "HTTP", "HTTPS", "Ping"]
  """
  def monitor_types, do: api_get "/monitor_types"

  @doc """
  Update a monitor; rely on user to properly format the json object that gets
  posted
  """
  def update_monitor(json), do: api_post "/monitors", json

  @doc """
  get a list of all endpoints and their details

      iex> {:ok, endpoints} = Worldping.endpoints
      ...> Map.keys(hd(endpoints))
      ["id", "name", "org_id", "slug", "tags"]
  """
  def endpoints, do: api_get "/endpoints"

  @doc """
  get the details of specific endpoints - note that you query by tag, not
  endpoint id or name or slug

      iex> {:ok, endpoints} = Worldping.endpoints("bbg_homepage")
      ...> Map.keys(hd(endpoints))
      ["id", "name", "org_id", "slug", "tags"]

      iex> Worldping.endpoints("empty tag")
      {:ok, []}
  """
  def endpoints(tag), do: api_get "/endpoints", %{tag: tag}

  @doc """
  Model for body:
  {
    "name": "www.raintank.io",
    "tags": [
      "raintank"
    ],
    "monitors": [
      {
        "monitor_type_id": 1,
        "settings": [
          {
            "variable": "host",
            "value": "www.raintank.io"
          },
          {
            "variable": "port",
            "value": "80"
          },
          {
            "variable": "path",
            "value": "/"
          },
          {
            "variable": "timeout",
            "value": "5"
          },
          {
            "variable": "method",
            "value": "GET"
          },
          {
            "variable": "expectRegex",
            "value": ""
          }
        ],
        "endpoint_id": -1,
        "collector_ids": [
          1,
          2,
          3,
          4
        ],
        "collector_tags": [],
        "enabled": true,
        "frequency": 60,
        "health_settings": {
          "steps": 3,
          "num_collectors": 3,
          "notifications": {
            "enabled": false,
            "addresses": ""
          }
        }
      },
      {
        "monitor_type_id": 3,
        "settings": [
          {
            "variable": "hostname",
            "value": "www.raintank.io"
          },
          {
            "variable": "timeout",
            "value": "5"
          }
        ],
        "endpoint_id": -1,
        "collector_ids": [
          1,
          2,
          3,
          4
        ],
        "collector_tags": [],
        "enabled": true,
        "frequency": 10,
        "health_settings": {
          "steps": 3,
          "num_collectors": 3,
          "notifications": {
            "enabled": false,
            "addresses": ""
          }
        }
      }
    ]
  }

  "tags" is a list of strings
  "monitors" is a list of JSONs specifying each monitor to be created
  """
  def create_endpoint(name, tags \\ [], monitors \\ [])
  def create_endpoint(name, tags, monitors) do
    Poison.encode(%{name: name, tags: tags, monitors: monitors})
    |> create_endpoint_from_json
  end

  # Create an endpoint on remote server; rely on calling function to properly
  # format the json object that gets posted
  defp create_endpoint_from_json(json), do: api_put "/endpoints", json

end
