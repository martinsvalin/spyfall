defmodule SpyfallWeb.PageController do
  use SpyfallWeb, :controller

  def index(conn, _params) do
    assign(conn, :locations, ["1", "2", "3"])
    |> render("index.html")
  end
end
