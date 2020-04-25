defmodule SpyfallWeb.GameLive do
  use SpyfallWeb, :live_view
  alias Phoenix.PubSub
  alias Spyfall.Players

  @impl true
  def mount(%{"game_id" => game_id}, _session, socket) do
    topic = "game:#{game_id}"
    PubSub.subscribe(Spyfall.PubSub, topic)
    Players.track(self(), topic, socket.id, %{name: initial_name()})

    players = Players.list(topic) |> Enum.map(&dig_out_name/1)

    {:ok, assign(socket, :players, players)}
  end

  @impl true
  def handle_info(
        %{event: "presence_diff", payload: %{joins: joins, leaves: leaves}},
        %{assigns: %{players: players}} = socket
      ) do
    {:noreply, socket}
  end

  @impl true
  def render(%{players: players} = assigns) do
    ~L"""
    Woah! These are the players: <%= Enum.join(players, ", ") %>!
    """
  end

  def initial_name() do
    "wonder woman"
  end

  def dig_out_name({_presence_id, %{metas: metas}}) do
    Enum.find_value(metas, fn map -> map[:name] end)
  end
end
