ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(PhoenixLiveviewStockTracker.Repo, :manual)

Mox.defmock(PhoenixLiveviewStockTracker.AlphaVantageApiClientMock,
  for: PhoenixLiveviewStockTracker.AlphaVantageApiClientBehaviour
)

Application.put_env(
  :phoenix_liveview_stock_tracker,
  :alpha_vantage_api_client,
  PhoenixLiveviewStockTracker.AlphaVantageApiClientMock
)

Mox.defmock(HttpMock, for: HTTPoison.Base)

Application.put_env(
  :phoenix_liveview_stock_tracker,
  :http_client,
  HttpMock
)
