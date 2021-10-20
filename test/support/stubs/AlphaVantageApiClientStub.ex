defmodule PhoenixLiveviewStockTracker.AlphaVantageApiClientStub do
  @behaviour PhoenixLiveviewStockTracker.AlphaVantageApiClientBehaviour

  def get_time_series("AAPL") do
    {
      :ok,
      %{
        time_series: %{
          "2021-10-18 19:05:00" => %{price: "146.1800"},
          "2021-10-18 19:10:00" => %{price: "146.6800"}
        }
      }
    }
  end

  def get_time_series("TSLA") do
    {
      :ok,
      %{
        time_series: %{
          "2021-10-18 19:05:00" => %{price: "246.1800"},
          "2021-10-18 19:10:00" => %{price: "246.6800"}
        }
      }
    }
  end

  def get_time_series(_) do
    {
      :error,
      %{
        status_code: 200,
        body:
          "{\"Error Message\":\"Invalid API call. Please retry or visit the documentation (https://www.alphavantage.co/documentation/) for TIME_SERIES_INTRADAY.\"}"
      }
    }
  end

  def search_stocks("Tesl") do
    {
      :ok,
      [
        %{
          symbol: "TSLA",
          name: "Tesla Inc"
        },
        %{
          symbol: "TL0.DEX",
          name: "Tesla Inc"
        },
        %{
          symbol: "TL0.FRK",
          name: "Tesla Inc"
        },
        %{
          symbol: "TSLA34.SAO",
          name: "Tesla Inc"
        }
      ]
    }
  end

  def search_stocks(_) do
    {:ok, []}
  end
end
