defmodule SpyfallWeb.GameLive do
  use SpyfallWeb, :live_view
  alias Phoenix.PubSub
  alias Spyfall.{Games, Player}

  @impl true
  def mount(%{"game_id" => game_id}, %{"identity" => identity} = session, socket) do
    if connected?(socket) do
      Games.register(game_id, identity)

      topic = "game:" <> game_id
      PubSub.subscribe(Spyfall.PubSub, topic)

      Player.track(self(), topic, identity, %{
        name: Map.get(session, "name", Player.initial_name())
      })
    end

    {:ok,
     assign(socket,
       game: game_id,
       locations: Spyfall.locations(),
       player_id: identity,
       online: Player.online(game_id),
       card: Games.card(game_id, identity),
       timestamp: Games.started_at(game_id)
     )}
  end

  @impl true
  def handle_event("deal_cards", _, socket) do
    Spyfall.deal_cards(socket.assigns.game, Player.online(socket.assigns.game))
    PubSub.broadcast!(Spyfall.PubSub, "game:" <> socket.assigns.game, "card")

    {:noreply, socket}
  end

  def handle_event("new_name", %{"value" => new_name}, socket) do
    Player.update(
      self(),
      "game:" <> socket.assigns.game,
      socket.assigns.player_id,
      %{name: new_name}
    )

    {:noreply, socket}
  end

  @impl true
  def handle_info(%{event: "presence_diff"}, socket) do
    {:noreply, assign(socket, :online, Player.online(socket.assigns.game))}
  end

  def handle_info("card", socket) do
    card = Games.card(socket.assigns.game, socket.assigns.player_id)
    {:noreply, assign(socket, card: card, timestamp: Games.started_at(socket.assigns.game))}
  end
end
