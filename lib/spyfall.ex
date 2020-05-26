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

  @external_resource File.read!("lib/spyfall2-cards.json")
  @locations Jason.decode!(@external_resource)
  @spy %{role: "Spy", location: "Unknown", illustration: "🕵️‍♀️"}
  defp assign_cards(players) do
    {location, %{"roles" => roles, "illustration" => illustration}} = @locations |> Enum.random()

    cards =
      roles
      |> Enum.shuffle()
      |> Enum.map(&%{role: &1, location: location, illustration: illustration})

    [first_id | rest] = players |> Map.keys() |> Enum.shuffle()

    [{first_id, @spy} | Enum.zip(rest, cards)]
    |> Map.new()
  end

  def locations() do
    for {key, %{"illustration" => illustration}} <- @locations do
      {key, illustration}
    end
  end
end
