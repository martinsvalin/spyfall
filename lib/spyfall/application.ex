defmodule Spyfall.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      SpyfallWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Spyfall.PubSub},
      # Start the Endpoint (http/https)
      SpyfallWeb.Endpoint,
      Spyfall.Players
      # Start a worker by calling: Spyfall.Worker.start_link(arg)
      # {Spyfall.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Spyfall.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    SpyfallWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
