# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :scaffold_aptos_based_on_ai,
  ecto_repos: [ScaffoldAptosBasedOnAI.Repo]

# Configures the endpoint
config :scaffold_aptos_based_on_ai, ScaffoldAptosBasedOnAIWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: ScaffoldAptosBasedOnAIWeb.ErrorHTML, json: ScaffoldAptosBasedOnAIWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: ScaffoldAptosBasedOnAI.PubSub,
  live_view: [signing_salt: "8Hv+cWMw"]

config :openai,
  # find it at https://platform.openai.com/account/api-keys
  api_key: System.get_env("OPENAI_SECRET"),
  # # find it at https://platform.openai.com/account/org-settings under "Organization ID"
  # organization_key: "your-organization-key",
  # optional, passed to [HTTPoison.Request](https://hexdocs.pm/httpoison/HTTPoison.Request.html) options
  http_options: [recv_timeout: 30_000]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :scaffold_aptos_based_on_ai, ScaffoldAptosBasedOnAI.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.15.5",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.2.4",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :petal_components,
       :error_translator_function,
       {ScaffoldAptosBasedOnAIWeb.CoreComponents, :translate_error}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
