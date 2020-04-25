defmodule Spyfall.Players do
  use Phoenix.Presence,
    otp_app: :spyfall,
    pubsub_server: Spyfall.PubSub
end
