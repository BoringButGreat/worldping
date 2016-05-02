defmodule Worldping do
  @docmodule """
  Tools for getting data from the Worldping API
  """

  @api_host Application.get_env(:worldping, :api_host)
  @api_key Application.get_env(:worldping, :api_key)
  @headers ["Authorization": @api_key]

  @doc """
  Each Worldping API query accesses a different URL, not just different query arguments,
  so for clarity each type of Worldping API call gets its own function
  """

  @doc """
  Call the monitors query for ALL endpoints
  """
  def monitors, do: api_get "/monitors"

  @doc """
  Call the monitors query for a specific endpoint
  """
  def monitors(endpoint), do: api_get "/monitors", %{endpoint_id: endpoint}

  @doc """
  Get a list of monitor types
  """
  def monitor_types, do: api_get "/monitor_types"

  @doc """
  Update a monitor; rely on user to properly format the json object that gets posted
  """
  def update_monitor(json), do: api_post "/monitors", json

  @doc """
  get a list of all endpoints and their details
  """
  def endpoints, do: api_get "/endpoints"

  @doc """
  get the details of specific endpoints - note that you query by tag, not
  endpoint id or name or slug
  """
  def endpoints(tag), do: api_get "/endpoints", %{tag: tag}

  # Inside each individual API query, we can use a generic API call by sending the
  # appropriate arguments to the right path.
  defp api_get(path) do
    HTTPotion.get(@api_host <> path, [headers: @headers])
      |> validate
  end
  defp api_get(path, query_args) do
    HTTPotion.get(@api_host <> path, [headers: @headers, query: query_args])
      |> validate
  end

  defp api_post(path, body) do
    HTTPotion.post(@api_host <> path, [body: body, headers: @headers])
      |> validate
  end

  defp validate(response) do
    if HTTPotion.Response.success?(response) do
      {:ok, response.body}
    else
      {:error, "#{inspect(response)}"}
    end
  end
end
