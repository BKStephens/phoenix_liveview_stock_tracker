defmodule PhoenixLiveviewStockTracker.Repo do
  use Ecto.Repo,
    otp_app: :phoenix_liveview_stock_tracker,
    adapter: Ecto.Adapters.Postgres
end
