defmodule SpyfallWeb.GameLive do
  use SpyfallWeb, :live_view
  alias Phoenix.PubSub
  alias Spyfall.{Games, Player}

  @impl true
  def mount(%{"game_id" => game_id}, _session, socket) do
    topic = "game:#{game_id}"
    PubSub.subscribe(Spyfall.PubSub, topic)
    Player.track(self(), topic, socket.id, %{})

    Games.register(game_id, socket.id)

    new_socket =
      socket
      |> assign(:game, game_id)
      |> assign(:online, Player.online(game_id))

    {:ok, new_socket}
  end

  @impl true
  def handle_info(%{event: "presence_diff"}, socket) do
    {:noreply, assign(socket, :online, Player.online(socket.assigns.game))}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <h2>Players online</h2>
    <ul>
      <%= for {_id, player} <- Map.take(Games.players(assigns.game), assigns.online), do: raw("<li>#{player.name}</li>") %>
    </ul>
    """
  end
end
