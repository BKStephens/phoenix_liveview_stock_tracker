defmodule PhoenixLiveviewStockTracker.Stocks do
  def get_stock(symbol) do
    with {:ok, %{time_series: time_series}} <- alpha_vantage_api_client().get_time_series(symbol),
         {_, %{price: price}} = Map.to_list(time_series) |> List.last() do
      {:ok, %{symbol: symbol, price: price}}
    else
      _ ->
        {:error,
         "Something went wrong. Please make sure you are passing in a valid stock symbol."}
    end
  end

  defp alpha_vantage_api_client do
    Application.get_env(:phoenix_liveview_stock_tracker, :alpha_vantage_api_client)
  end
end
