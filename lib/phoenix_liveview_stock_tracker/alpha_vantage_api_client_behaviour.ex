defmodule PhoenixLiveviewStockTracker.AlphaVantageApiClientBehaviour do
  @callback get_time_series(String.t()) :: tuple()
  @callback search_stocks(String.t()) :: tuple()
end
