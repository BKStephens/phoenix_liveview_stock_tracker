defmodule PhoenixLiveviewStockTrackerWeb.StocksLive do
  use PhoenixLiveviewStockTrackerWeb, :live_view
  alias PhoenixLiveviewStockTracker.Stocks

  def mount(_params, _session, socket) do
    socket = assign(socket, stock: nil, query: nil, loading: false, matches: [])
    {:ok, socket}
  end

  def handle_event("suggest", %{"q" => ""}, socket) do
    {:noreply, assign(socket, matches: [])}
  end

  def handle_event("suggest", %{"q" => query}, socket) do
    matches =
      if Enum.any?(socket.assigns.matches, &(&1.symbol == query)) do
        socket.assigns.matches
      else
        {:ok, stocks} = Stocks.search_stocks(query)
        stocks
      end

    {:noreply, assign(socket, matches: matches)}
  end

  def handle_event("search", %{"q" => ""}, socket) do
    {:noreply, assign(socket, query: "", stock: nil, loading: false, matches: [])}
  end

  def handle_event("search", %{"q" => query}, socket) do
    send(self(), {:search, query})
    {:noreply, assign(socket, query: query, loading: true, matches: [])}
  end

  def handle_info({:search, symbol}, socket) do
    {:ok, stock} = Stocks.get_stock(symbol)
    {:noreply, assign(socket, loading: false, stock: stock, matches: [])}
  end

  def render(assigns) do
    PhoenixLiveviewStockTrackerWeb.StocksLiveView.render("stocks_live.html", assigns)
  end
end
