defmodule Spyfall do
  @moduledoc """
  Spyfall keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias Spyfall.{Games, Player}

  def deal_cards(game, presences) do
    Games.players(game, Map.keys(presences))
    |> assign_cards()
    |> Games.update_players(game)
  end

  @locations ["Airport ✈️", "Rock concert 🎸", "Cemetery ⚰️", "Nursing home 🛌"]
  defp assign_cards(players) do
    location = Enum.random(@locations)
    [{key, %Player{} = player} | rest] = Enum.shuffle(players)

    Map.new([{key, %{player | card: "Spy 🕵️‍♀️"}} | for {key, player} <- rest  do {key, %{player | card: location}} end])
  end
end
