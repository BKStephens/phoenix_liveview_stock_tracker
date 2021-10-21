defmodule PhoenixLiveviewStockTracker.AlphaVantageApiClient do
  @behaviour PhoenixLiveviewStockTracker.AlphaVantageApiClientBehaviour
  @api_key Application.get_env(:phoenix_liveview_stock_tracker, :alpha_vantage_api_key)

  def get_time_series(symbol) do
    with {:ok, %{status_code: 200, body: raw_body}} <-
           http_client().get(
             "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=#{symbol}&interval=5min&apikey=#{@api_key}'"
           ),
         {:ok, %{"Time Series (5min)" => raw_time_series}} <- Poison.decode(raw_body) do
      time_series =
        raw_time_series
        |> Enum.map(fn {k, v} ->
          {k, %{price: v["2. high"]}}
        end)
        |> Map.new()

      {:ok, %{time_series: time_series}}
    else
      {:ok, body} -> {:error, body}
    end
  end

  def search_stocks(query) do
    with {:ok, %{status_code: 200, body: raw_body}} <-
           http_client().get(
             "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=#{query}&apikey=#{@api_key}'"
           ),
         {:ok, %{"bestMatches" => raw_matches}} <- Poison.decode(raw_body) do
      matches =
        raw_matches
        |> Enum.map(fn x ->
          %{
            symbol: x["1. symbol"],
            name: x["2. name"]
          }
        end)

      {:ok, matches}
    else
      {:ok, body} -> {:error, body}
    end
  end

  defp http_client do
    Application.get_env(:phoenix_liveview_stock_tracker, :http_client)
  end
end
