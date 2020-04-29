defmodule Spyfall.Games do
  use Agent
  alias Spyfall.Player

  def start_link([]) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def players(game, player_ids) do
    Agent.get(__MODULE__, fn state ->
      players = get_in(state, [game, :players]) || %{}
      Map.take(players, player_ids)
    end)
  end

  def player(game, player_id) do
    Agent.get(__MODULE__, fn state ->
      get_in(state, [game, :players, player_id])
    end)
  end

  def debug(), do: Agent.get(__MODULE__, & &1)

  def register(game, player_id) do
    Agent.update(__MODULE__, fn state ->
      Map.update(
        state,
        game,
        put_in(new(), [:players, player_id], Player.new()),
        &put_in(&1, [:players, player_id], Player.new())
      )
    end)
  end

  def update_players(players, game) do
    Agent.update(__MODULE__, fn state ->
      Map.update(
        state,
        game,
        Map.put(new(), :players, players),
        &Map.put(&1, :players, players)
      )
    end)
  end

  defp new(), do: %{players: %{}}
end
