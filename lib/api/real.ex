defmodule Worldping.API.Real do
  defp api_host, do: Application.get_env(:worldping, :api_host)
  defp api_key, do: Application.get_env(:worldping, :api_key)
  defp auth_header, do: ["Authorization": api_key]
  defp json_header, do: ["Content-Type": "application/json"]

  # Inside each individual API query, we can use a generic API call by sending the
  # appropriate arguments to the right path.
  #
  # NOTE: if you add a function here and call it elsewhere, you must add a
  # corresponding function to fake.ex. This project will still compile if you
  # don't, but "mix test" will fail - this will likely cause problems for
  # someone else who is using the Worldping API in their project.
  def api_get(path) do
    HTTPotion.get(api_host <> path, [headers: auth_header])
    |> validate
  end
  def api_get(path, query_args) do
    HTTPotion.get(api_host <> path, [headers: auth_header, query: query_args])
    |> validate
  end

  def api_post(path, body) do
    HTTPotion.post(api_host <> path, [body: body, headers: auth_header++json_header])
    |> validate
  end

  def api_put(path, body) do
    HTTPotion.put(api_host <> path, [body: body, headers: auth_header++json_header])
    |> validate
  end

  def api_delete(path) do
    HTTPotion.delete(api_host <> path, [headers: auth_header])
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
