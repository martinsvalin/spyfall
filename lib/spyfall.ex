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

  @locations %{
    "Art museum 🖼" => ["Student", "Guide", "Visitor", "Director", "Caretaker", "Restorer", "Souvenir Seller", "Ticket Seller", "Art Historian", "Security Guard"],
    "Candy factory 🍬" => ["Taster", "Taffy Puller", "Eccentric Owner", "Master Chef", "Sugar Duster", "Storekeeper", "Madcap Redhead", "Swirler", "Pastry Chef", "Visitor"],
    "Cat show 🐈" => ["Cat Handler", "Expert", "Visitor", "Judge", "Organizer", "Veterinarian", "Groomer", "Crazy Cat Lover", "Child", "Cat"],
    "Cemetery ⚰️" => ["Grave Robber", "Undertaker", "Gravedigger", "Florist", "Inconsolable Relative", "Priest", "Zombie", "Gardener", "Heir", "Gothic Girl"],
    "Coal mine ⛏" => ["Miner", "Mole Person", "Blaster", "Loader", "Surveyor", "Environmentalist", "Foreman", "Geologist", "Safety Inspector", "Canary"],
    "Contruction site 👷‍♀️" => ["Contractor", "Foreman", "Crane Operator", "General Laborer", "Trainee", "Free-Roaming Toddler", "Welder", "Electrician", "Painter", "Client"],
    "Gas station ⛽️" => ["Service Assistant", "Cashier", "Tanker Driver", "Carwasher", "Motorcyclist", "Car Enthusiast", "Slow Pumper", "Road-Tripper", "Impatient Customer", "Child in Car Seat"],
    "Harbor docks 🚢" => ["Captain", "Passenger", "Loader", "Sailor", "Mermaid", "Crane Operator", "Customs Official", "Smuggler", "HarborMaster", "Salty Old Pirate"],
    "Jail 🔫" => ["Guard", "Prisoner", "Visitor", "Snitch", "Warden", "Psychiatrist", "Maniac", "Lawyer", "Cook", "Bully"],
    "Jazz club 🎷" => ["Trumpet Player", "Hepcat", "Bartender", "Music Lover", "Drummer", "Saxophonist", "Bouncer", "Guitar Player", "Singer"],
    "Library 📚" => ["Librarian", "Bookworm", "Old Man", "Researcher", "Journalist", "Author", "Student", "Volunteer", "Know-It-All", "Archivist"],
    "Retirement home 🛌" => ["Event Coordinator", "Relative", "Grump", "Cook", "Knitting Enthusiast", "Old Man", "Elderly Woman", "Cribbage Player", "Nurse", "Visitor"],
    "Race track 🏎" => ["Driver", "Pit Crew", "Team Owner", "Commentator", "Medic", "Firefighter", "Flagman", "Fan", "Journalist", "Girl with Champagne"],
    "Rock concert 🎸" => ["Singer", "Guitarist", "Bass Guitar Player", "Drummer", "Keyboard Player", "Manager", "Fan", "Dancer", "Bouncer", "Roadie"],
    "Sightseeing bus 🚌" => ["Tour Manager", "Nervous Woman", "Obnoxious Child", "Photographer", "Sleeping Passenger", "Disinterested Teen", "Enthusiastic Tourist", "Driver", "Tour Guide", "Old Man"],
    "Stadium 🏟" => ["Hammer Thrower", "Sprinter", "Pole Vaulter", "Coach", "Referee", "Medic", "Fan", "Vendor", "Commentator", "Doping Control Examiner"],
    "Subway 🚇" => ["Policeman", "Harried Commuter", "Janitor", "Subway Operator", "Passenger", "Beggar", "Tourist", "Turnstile Jumper", "Cashier", "Creepy Dude"],
    "The U.N. 🏛" => ["Secretary General", "Speaker", "Secretary of State", "Journalist", "Interpreter", "Lobbyist", "Diplomat", "Tourist", "Napping Delegate", "Blowhard"],
    "Vineyard 🍷" => ["Taster", "Vintager", "Winemaker", "Tourist", "Gourmet Guide", "Sommelier", "Gardener", "Field Worker", "Wine Seller", "Waiter"],
    "Wedding 👰" => ["Groom", "Bride", "Photographer", "Officiant", "Flower Girl", "Father of the Bride", "Bridesmaid", "Ring Bearer", "Best Man", "Wedding Crasher"],
  }
  @spy %{role: "Spy 🕵️‍♀️", location: "Unknown"}
  defp assign_cards(players) do
    {location, roles} = @locations |> Enum.random()
    cards = roles |> Enum.shuffle |> Enum.map(&%{role: &1, location: location})

    [first_id | rest] = players |> Map.keys() |> Enum.shuffle()

    [{first_id, @spy} | Enum.zip(rest, cards)]
    |> Map.new()
  end

  def locations(), do: Map.keys(@locations)
end
