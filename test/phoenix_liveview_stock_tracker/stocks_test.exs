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

      assert actual == {:ok, %{symbol: "AAPL", price: "146.6800"}}
    end

    test "returns an error when invalid symbol passed in" do
      actual = Stocks.get_stock("INVALID")

      assert actual ==
               {:error,
                "Something went wrong. Please make sure you are passing in a valid stock symbol."}
    end
  end
end
