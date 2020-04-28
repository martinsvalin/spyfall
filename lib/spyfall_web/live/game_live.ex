defmodule SpyfallWeb.GameLive do
  use SpyfallWeb, :live_view
  alias Phoenix.PubSub
  alias Spyfall.{Games, Player}

  @impl true
  def mount(%{"game_id" => game_id}, _session, socket) do
    if connected?(socket) do
      Games.register(game_id, socket.id)

      topic = "game:#{game_id}"
      PubSub.subscribe(Spyfall.PubSub, topic)
      Player.track(self(), topic, socket.id, %{})
    end

    {:ok, assign(socket, game: game_id, player_id: socket.id, online: online_players(game_id))}
  end

  @impl true
  def handle_info(%{event: "presence_diff"}, socket) do
    {:noreply, assign(socket, :online, online_players(socket.assigns.game))}
  end

  defp online_players(game_id) do
    Games.players(game_id)
    |> Map.take(Player.online(game_id))
    |> Map.values()
  end
end
