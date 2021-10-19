# PhoenixLiveviewStockTracker

## Setup

```
cp config/dev.secret.exs.template config/dev.secret.exs
```

Then open config/dev.secret.exs and put in your API keys.
- [See here](https://www.alphavantage.co/support/#api-key) to get an Alpha Vantage API key.

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
