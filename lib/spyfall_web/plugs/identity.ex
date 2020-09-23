defmodule SpyfallWeb.Plugs.Identity do
  import Plug.Conn

  def init(options), do: options

  def call(conn, _opts) do
    if get_session(conn, :identity) do
      conn
    else
      put_session(conn, :identity, UUID.uuid4())
    end
  end
end
