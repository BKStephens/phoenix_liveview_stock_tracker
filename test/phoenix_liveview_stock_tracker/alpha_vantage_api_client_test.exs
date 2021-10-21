defmodule PhoenixLiveviewStockTracker.AlphaVantageApiClientTest do
  use ExUnit.Case, async: true
  alias PhoenixLiveviewStockTracker.AlphaVantageApiClient
  import Mox
  setup :verify_on_exit!

  describe "get_time_series" do
    test "returns data for AAPL" do
      expect(HttpMock, :get, fn _ ->
        {:ok,
         %{
           status_code: 200,
           body:
             "{\"Meta Data\":{\"1. Information\":\"Intraday (5min) open, high, low, close prices and volume\",\"2. Symbol\":\"aapl\",\"3. Last Refreshed\":\"2021-10-18 19:10:00\",\"4. Interval\":\"5min\",\"5. Output Size\":\"Compact\",\"6. Time Zone\":\"US/Eastern\"},\"Time Series (5min)\":{\"2021-10-18 19:05:00\":{\"1. open\":\"140.0000\",\"2. high\":\"146.1800\",\"3. low\":\"145.7000\",\"4. close\":\"146.1700\",\"5. volume\":\"10629\"},\"2021-10-18 19:10:00\":{\"1. open\":\"140.0000\",\"2. high\":\"146.6800\",\"3. low\":\"145.7500\",\"4. close\":\"146.3700\",\"5. volume\":\"3479\"}}}"
         }}
      end)

      actual = AlphaVantageApiClient.get_time_series("AAPL")

      assert actual ==
               {:ok,
                %{
                  time_series: %{
                    "2021-10-18 19:05:00" => %{price: "146.1800"},
                    "2021-10-18 19:10:00" => %{price: "146.6800"}
                  }
                }}
    end

    test "returns an error when invalid symbol passed in" do
      expect(HttpMock, :get, fn _ ->
        {:ok,
         %{
           status_code: 200,
           body:
             "{\"Error Message\":\"Invalid API call. Please retry or visit the documentation (https://www.alphavantage.co/documentation/) for TIME_SERIES_INTRADAY.\"}"
         }}
      end)

      actual = AlphaVantageApiClient.get_time_series("INVALID")

      assert actual ==
               {:error,
                %{
                  "Error Message" =>
                    "Invalid API call. Please retry or visit the documentation (https://www.alphavantage.co/documentation/) for TIME_SERIES_INTRADAY."
                }}
    end
  end

  describe "search_stocks" do
    test "returns data for Tesl" do
      expect(HttpMock, :get, fn _ ->
        {:ok,
         %{
           status_code: 200,
           body:
             "{\"bestMatches\":[{\"1. symbol\":\"TSLA\",\"2. name\":\"Tesla Inc\",\"3. type\":\"Equity\",\"4. region\":\"United States\",\"5. marketOpen\":\"09:30\",\"6. marketClose\":\"16:00\",\"7. timezone\":\"UTC-04\",\"8. currency\":\"USD\",\"9. matchScore\":\"0.7500\"},{\"1. symbol\":\"TL0.DEX\",\"2. name\":\"Tesla Inc\",\"3. type\":\"Equity\",\"4. region\":\"XETRA\",\"5. marketOpen\":\"08:00\",\"6. marketClose\":\"20:00\",\"7. timezone\":\"UTC+02\",\"8. currency\":\"EUR\",\"9. matchScore\":\"0.6154\"},{\"1. symbol\":\"TL0.FRK\",\"2. name\":\"Tesla Inc\",\"3. type\":\"Equity\",\"4. region\":\"Frankfurt\",\"5. marketOpen\":\"08:00\",\"6. marketClose\":\"20:00\",\"7. timezone\":\"UTC+02\",\"8. currency\":\"EUR\",\"9. matchScore\":\"0.6154\"},{\"1. symbol\":\"TSLA34.SAO\",\"2. name\":\"Tesla Inc\",\"3. type\":\"Equity\",\"4. region\":\"Brazil/Sao Paolo\",\"5. marketOpen\":\"10:00\",\"6. marketClose\":\"17:30\",\"7. timezone\":\"UTC-03\",\"8. currency\":\"BRL\",\"9. matchScore\":\"0.6154\"}]}"
         }}
      end)

      actual = AlphaVantageApiClient.search_stocks("Tesl")

      assert actual ==
               {:ok,
                [
                  %{
                    symbol: "TSLA",
                    name: "Tesla Inc"
                  }
                ]}
    end

    test "returns empty bestMatches for INVALID" do
      expect(HttpMock, :get, fn _ ->
        {:ok,
         %{
           status_code: 200,
           body: "{\"bestMatches\":[]}"
         }}
      end)

      actual = AlphaVantageApiClient.search_stocks("INVALID")

      assert actual == {:ok, []}
    end
  end
end
