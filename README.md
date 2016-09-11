# DisqueEx

Elixir client for Disque message queue. Aims to provide all the commands.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `disque_ex` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:disque_ex, "~> 0.1.0"}]
    end
    ```

  2. Ensure `disque_ex` is started before your application:

    ```elixir
    def application do
      [applications: [:disque_ex]]
    end
    ```

