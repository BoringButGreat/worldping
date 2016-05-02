defmodule Worldping.API do
  defmacro __using__(_) do
    case Application.get_env(:worldping, :api_host) do
      "test" <> _ ->
        quote do
          import Worldping.API.Fake
        end
      _ ->
        quote do
          import Worldping.API.Real
        end
    end
  end
end
