defmodule SpyfallWeb.SessionController do
  use SpyfallWeb, :controller

  def set_name(conn, %{"name" => name}) do
    conn
    |> put_session(:name, name)
    |> json(true)
  end
end
