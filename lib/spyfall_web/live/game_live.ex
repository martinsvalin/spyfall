defmodule SpyfallWeb.GameLive do
  use SpyfallWeb, :live_view
  alias Phoenix.PubSub
  alias Spyfall.{Games, Player}

  @impl true
  def mount(%{"game_id" => game_id}, _session, socket) do
    if connected?(socket) do
      Games.register(game_id, socket.id)

      topic = "game:" <> game_id
      PubSub.subscribe(Spyfall.PubSub, topic)
      Player.track(self(), topic, socket.id, %{name: Player.initial_name()})
    end

    {:ok,
     assign(socket,
       game: game_id,
       player_id: socket.id,
       online: Player.online(game_id),
       card: nil
     )}
  end

  @impl true
  def handle_event("deal_cards", _, socket) do
    Spyfall.deal_cards(socket.assigns.game, Player.online(socket.assigns.game))
    PubSub.broadcast!(Spyfall.PubSub, "game:" <> socket.assigns.game, "card")

    {:noreply, socket}
  end

  @impl true
  def handle_info(%{event: "presence_diff"}, socket) do
    {:noreply, assign(socket, :online, Player.online(socket.assigns.game))}
  end

  def handle_info("card", socket) do
    card = Games.card(socket.assigns.game, socket.assigns.player_id)
    {:noreply, assign(socket, card: card)}
  end
end
