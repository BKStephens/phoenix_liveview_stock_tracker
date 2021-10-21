defmodule PhoenixLiveviewStockTracker.StocksTest do
  use ExUnit.Case, async: true

  alias PhoenixLiveviewStockTracker.Stocks

  setup do
    Mox.stub_with(
      PhoenixLiveviewStockTracker.AlphaVantageApiClientMock,
      PhoenixLiveviewStockTracker.AlphaVantageApiClientStub
    )

    :ok
  end

  describe "get_stock" do
    test "returns Apple stock info when AAPL passed in" do
      actual = Stocks.get_stock("AAPL")

      assert actual == {:ok, %{symbol: "AAPL", price: "$146.68"}}
    end

    test "returns an error when invalid symbol passed in" do
      actual = Stocks.get_stock("INVALID")

      assert actual ==
               {:error,
                "Something went wrong. Please make sure you are passing in a valid stock symbol or try again in a minute."}
    end
  end

  describe "search_stocks" do
    test "returns results for Tesl" do
      actual = Stocks.search_stocks("Tesl")

      assert actual ==
               {:ok,
                [
                  %{
                    symbol: "TSLA",
                    name: "Tesla Inc"
                  }
                ]}
    end

    test "returns empty results for INVALID" do
      actual = Stocks.search_stocks("INVALID")

      assert actual == {:ok, []}
    end
  end
end
