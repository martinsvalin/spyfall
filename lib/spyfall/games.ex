defmodule Spyfall.Games do
  use Agent

  def start_link([]) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def debug(), do: Agent.get(__MODULE__, & &1)

  def register(game, player_id) do
    Agent.update(__MODULE__, fn state ->
      Map.update(
        state,
        game,
        put_in(new(), [:cards, player_id], nil),
        fn game ->
          {_, new_game} = get_and_update_in(game, [:cards, player_id], &{&1, &1})
          new_game
        end
      )
    end)
  end

  def cards(game, player_ids) do
    Agent.get(__MODULE__, fn state ->
      cards = get_in(state, [game, :cards]) || %{}
      Map.take(cards, player_ids)
    end)
  end

  def card(game, player_id) do
    Agent.get(__MODULE__, fn state ->
      get_in(state, [game, :cards, player_id])
    end)
  end

  def write_cards(cards, game) do
    Agent.update(__MODULE__, fn state ->
      Map.update(
        state,
        game,
        Map.put(new(), :cards, cards),
        &Map.put(&1, :cards, cards)
      )
    end)
  end

  defp new(), do: %{cards: %{}}
end
