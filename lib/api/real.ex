defmodule Worldping.API.Real do
  @api_host Application.get_env(:worldping, :api_host)
  @api_key Application.get_env(:worldping, :api_key)
  @headers ["Authorization": @api_key]

  # Inside each individual API query, we can use a generic API call by sending the
  # appropriate arguments to the right path.
  def api_get(path) do
    HTTPotion.get(@api_host <> path, [headers: @headers])
    |> validate
  end
  def api_get(path, query_args) do
    HTTPotion.get(@api_host <> path, [headers: @headers, query: query_args])
    |> validate
  end

  def api_post(path, body) do
    HTTPotion.post(@api_host <> path, [body: body, headers: @headers])
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
