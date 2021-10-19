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
end
