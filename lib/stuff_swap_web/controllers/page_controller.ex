defmodule StuffSwapWeb.PageController do
  use StuffSwapWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
