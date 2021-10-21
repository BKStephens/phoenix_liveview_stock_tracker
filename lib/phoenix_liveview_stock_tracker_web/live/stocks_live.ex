defmodule PhoenixLiveviewStockTrackerWeb.StocksLive do
  use PhoenixLiveviewStockTrackerWeb, :live_view
  alias PhoenixLiveviewStockTracker.Stocks

  def mount(_params, _session, socket) do
    socket = assign_with_defaults(socket, stock: nil, query: nil, loading: false, matches: [])
    {:ok, socket}
  end

  def handle_event("suggest", %{"q" => ""}, socket) do
    {:noreply, assign_with_defaults(socket, matches: [])}
  end

  def handle_event("suggest", %{"q" => query}, socket) do
    matches =
      if Enum.any?(socket.assigns.matches, &(&1.symbol == query)) do
        {:ok, socket.assigns.matches}
      else
        Stocks.search_stocks(query)
      end

    case matches do
      {:ok, m} -> {:noreply, assign_with_defaults(socket, matches: m)}
      {:error, error} -> {:noreply, assign_with_defaults(socket, error: error)}
    end
  end

  def handle_event("search", %{"q" => ""}, socket) do
    {:noreply, assign_with_defaults(socket)}
  end

  def handle_event("search", %{"q" => query}, socket) do
    send(self(), {:search, query})
    {:noreply, assign_with_defaults(socket, query: query, loading: true)}
  end

  def handle_info({:search, symbol}, socket) do
    case Stocks.get_stock(symbol) do
      {:ok, stock} ->
        {:noreply, assign_with_defaults(socket, stock: stock, loading: false)}

      {:error, error} ->
        {:noreply, assign_with_defaults(socket, error: error, loading: false)}
    end
  end

  def render(assigns) do
    PhoenixLiveviewStockTrackerWeb.StocksLiveView.render("stocks_live.html", assigns)
  end

  defp assign_with_defaults(socket, assigns \\ []) do
    socket
    |> assign(error: nil)
    |> assign(assigns)
  end
end
