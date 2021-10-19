defmodule PhoenixLiveviewStockTrackerWeb.PageController do
  use PhoenixLiveviewStockTrackerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
