import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :phoenix_liveview_stock_tracker, PhoenixLiveviewStockTrackerWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "SYtzXZLCNYjiSxyTJJ8gV5U6CZnwkhgg60VkWJX1uh8sq+J6MOVPoIxb8AbBXJiy",
  server: false

# In test we don't send emails.
config :phoenix_liveview_stock_tracker, PhoenixLiveviewStockTracker.Mailer,
  adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
