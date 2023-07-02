defmodule ScaffoldAptosBasedOnAI.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ScaffoldSuiBasedOnAiWeb.Telemetry,
      # Start the Ecto repository
      ScaffoldAptosBasedOnAI.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: ScaffoldAptosBasedOnAI.PubSub},
      # Start Finch
      {Finch, name: ScaffoldAptosBasedOnAI.Finch},
      # Start the Endpoint (http/https)
      ScaffoldSuiBasedOnAiWeb.Endpoint
      # Start a worker by calling: ScaffoldAptosBasedOnAI.Worker.start_link(arg)
      # {ScaffoldAptosBasedOnAI.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ScaffoldAptosBasedOnAI.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ScaffoldSuiBasedOnAiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
