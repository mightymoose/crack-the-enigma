defmodule CrackTheEnigmaWeb.PageController do
  use CrackTheEnigmaWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
