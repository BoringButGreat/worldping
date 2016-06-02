defmodule Worldping.API.Real do
  @api_host Application.get_env(:worldping, :api_host)
  @api_key Application.get_env(:worldping, :api_key)
  @auth_header ["Authorization": @api_key]
  @json_header ["Content-Type": "application/json"]

  # Inside each individual API query, we can use a generic API call by sending the
  # appropriate arguments to the right path.
  def api_get(path) do
    HTTPotion.get(@api_host <> path, [headers: @auth_header])
    |> validate
  end
  def api_get(path, query_args) do
    HTTPotion.get(@api_host <> path, [headers: @auth_header, query: query_args])
    |> validate
  end

  def api_post(path, body) do
    HTTPotion.post(@api_host <> path, [body: body, header: @auth_header++@json_header])
    |> validate
  end

  def api_put(path, body) do
    HTTPotion.put(@api_host <> path, [body: body, header: @auth_header++@json_header])
    |> validate
  end

  def validate(response) do
    if HTTPotion.Response.success?(response) do
      Poison.decode(response.body)
    else
      {:error, "#{inspect(response)}"}
    end
  end
end
