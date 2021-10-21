defmodule PhoenixLiveviewStockTracker.Stocks do
  def get_stock(symbol) do
    with {:ok, %{time_series: time_series}} <- alpha_vantage_api_client().get_time_series(symbol),
         {_, %{price: raw_price}} <- Map.to_list(time_series) |> List.last(),
         {:ok, price} <- Money.parse(raw_price, :USD) do
      {:ok, %{symbol: symbol, price: Money.to_string(price)}}
    else
      _ ->
        {:error,
         "Something went wrong. Please make sure you are passing in a valid stock symbol or try again in a minute."}
    end
  end

  def search_stocks(query) do
    with {:ok, matches} <- alpha_vantage_api_client().search_stocks(query) do
      {:ok, matches}
    else
      _ ->
        {:error, "Something went wrong. Please try again in a minute."}
    end
  end

  defp alpha_vantage_api_client do
    Application.get_env(:phoenix_liveview_stock_tracker, :alpha_vantage_api_client)
  end
end
