defmodule Spyfall.Games do
  use Agent
  alias Spyfall.Player

  def start_link([]) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def players(game) do
    Agent.get(__MODULE__, &get_in(&1, [game, :players]))
  end

  def debug(), do: Agent.get(__MODULE__, & &1)

  def register(game, player_id) do
    Agent.update(__MODULE__, &update_game_with_player(&1, game, player_id))
  end

  defp update_game_with_player(state, game, player_id) do
    Map.update(
      state,
      game,
      put_in(new(), [:players, player_id], Player.new(player_id)),
      &put_in(&1, [:players, player_id], Player.new(player_id))
    )
  end

  defp new(), do: %{players: %{}}
end
