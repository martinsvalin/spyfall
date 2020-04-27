defmodule Spyfall.Player do
  use Phoenix.Presence,
    otp_app: :spyfall,
    pubsub_server: Spyfall.PubSub

  defstruct [:id, :name]

  def new(id) do
    %__MODULE__{id: id, name: initial_name()}
  end

  def online(game_id) do
    list("game:" <> game_id) |> Map.keys()
  end

  @color ~w(red green blue yellow white black orange pink purple brown beige gold silver scarlet maroon aquamarine indigo violet cerise sepia)
  @fruit ~w(apple pear orange banana melon lemon lime peach kiwi strawberry raspberry blueberry apricot plum grape mango avocado cherry papaya)
  @animal ~w(horse cow armadillo camel fox giraffe panda ladybug bee salmon eel piranha parrot flamingo frog spider falcon hedgehog llama lynx)
  defp initial_name() do
    [@color, @fruit, @animal] |> Enum.map(&Enum.random/1) |> Enum.join("-")
  end
end
