defmodule SpyfallWeb.PageController do
  use SpyfallWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
