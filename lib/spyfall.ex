defmodule Spyfall do
  @moduledoc """
  Spyfall keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias Spyfall.Games

  def deal_cards(game, presences) do
    Games.cards(game, Map.keys(presences))
    |> assign_cards()
    |> Games.write_cards(game)
  end

  @locations [
    "Airport ✈️",
    "Art museum 🖼",
    "Candy factory 🍬",
    "Cat show 🐈",
    "Cemetery ⚰️",
    "Coal mine ⛏",
    "Contruction site 👷‍♀️",
    "Gas station ⛽️",
    "Harbor docks 🚢",
    "Jail 🔫",
    "Jazz club 🎷",
    "Library 📚",
    "Retirement home 🛌",
    "Race track 🏎",
    "Rock concert 🎸",
    "Sightseeing bus 🚌",
    "Stadium 🏟",
    "Subway 🚇",
    "The U.N. 🏛",
    "Vineyard 🍷",
    "Wedding 👰",
  ]
  defp assign_cards(players) do
    location = Enum.random(@locations)
    [{player_id, _} | rest] = Enum.shuffle(players)

    Map.new([{player_id,  "Spy 🕵️‍♀️"} | for {player_id, _} <- rest do {player_id, location} end])
  end
end
