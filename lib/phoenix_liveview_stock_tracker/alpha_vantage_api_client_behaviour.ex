defmodule PhoenixLiveviewStockTracker.AlphaVantageApiClientBehaviour do
  @callback get_time_series(String.t()) :: tuple()
end
