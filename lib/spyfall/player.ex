defmodule Spyfall.Player do
  use Phoenix.Presence,
    otp_app: :spyfall,
    pubsub_server: Spyfall.PubSub

  def online(game_id), do: list("game:" <> game_id)

  @impl true
  def fetch(_topic, presences) do
    presences
    |> Map.new(&expose_name/1)
    |> set_dealer()
  end

  defp expose_name({key, %{name: _} = presence}), do: {key, presence}

  defp expose_name({key, presence}) do
    name = Enum.find_value(presence[:metas], fn meta -> meta[:name] end)
    {key, Map.put(presence, :name, name)}
  end

  defp set_dealer(presences) when map_size(presences) == 0, do: presences

  defp set_dealer(presences) do
    if Enum.find(presences, &match?({_, %{dealer: true}}, &1)) do
      presences
    else
      [{key, presence} | rest] = Map.to_list(presences)
      Map.new([{key, Map.put(presence, :dealer, true)} | rest])
    end
  end

  @color ~w(red green blue yellow white black orange pink purple brown beige gold silver scarlet maroon aquamarine indigo violet cerise sepia)
  @fruit ~w(apple pear orange banana melon lemon lime peach kiwi strawberry raspberry blueberry apricot plum grape mango avocado cherry papaya)
  @animal ~w(horse cow armadillo camel fox giraffe panda ladybug bee salmon eel piranha parrot flamingo frog spider falcon hedgehog llama lynx)
  def initial_name() do
    [@color, @fruit, @animal] |> Enum.map(&Enum.random/1) |> Enum.join("-")
  end
end
