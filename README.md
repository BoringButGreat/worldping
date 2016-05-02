# Worldping

Elixir tools for accessing the WorldPing API (see https://worldping.raintank.io).

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add worldping to your list of dependencies in `mix.exs`:

        def deps do
          [{:worldping, "~> 0.0.1"}]
        end

  2. Ensure worldping is started before your application:

        def application do
          [applications: [:worldping]]
        end

  3. Configure the api_key environment variable in your config files:

        config :worldping, api_key: "bearer <your_key>"
