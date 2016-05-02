# Worldping

Elixir tools for accessing the WorldPing API (see https://worldping.raintank.io).

## Installation

  1. Add worldping to your list of dependencies in `mix.exs`:
     ```elixir
     def deps do
       [{:worldping, "~> 0.0.1", github: "boringbutgreat/worldping"}]
     end
     ```

  2. Ensure worldping is started before your application:
     ```elixir
     def application do
       [applications: [:worldping]]
     end
     ```

  3. Configure the api_key environment variable in your config files:
     ```elixir
     config :worldping, api_key: "bearer <your_key>"
     ```

## Mocked mode
  ```elixir
  config :worldping, api_host: "test"
  ```
