# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :stuff_swap,
  ecto_repos: [StuffSwap.Repo]

# Configures the endpoint
config :stuff_swap, StuffSwapWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "6lgBfzZ+N1rdr2u0Y5p7Y38ScuQBdGonqnwBBtiJonSA7C41qXEPSQUgjIEzQZq4",
  render_errors: [view: StuffSwapWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: StuffSwap.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
