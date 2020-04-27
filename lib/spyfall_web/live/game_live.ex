defmodule SpyfallWeb.GameLive do
  use SpyfallWeb, :live_view
  alias Phoenix.PubSub
  alias Spyfall.Players

  @impl true
  def mount(%{"game_id" => game_id}, _session, socket) do
    topic = "game:#{game_id}"
    PubSub.subscribe(Spyfall.PubSub, topic)
    Players.track(self(), topic, socket.id, %{name: initial_name()})

    new_socket =
      socket
      |> assign(:topic, topic)
      |> assign(:players, players(topic))

    {:ok, new_socket}
  end

  @impl true
  def handle_info(%{event: "presence_diff"}, socket) do
    {:noreply, socket |> assign(:players, players(socket.assigns.topic))}
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

  defp players(topic) do
    Players.list(topic)
    |> Enum.map(&dig_out_name/1)
  end

  defp dig_out_name({_presence_id, %{metas: metas}}) do
    Enum.find_value(metas, fn map -> map[:name] end)
  end
end
