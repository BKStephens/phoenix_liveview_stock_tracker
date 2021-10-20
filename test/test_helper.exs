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

defmodule TestHelper do
  def wait_for_mailbox_to_drain(pid, max_milli \\ 5000, time_elapsed \\ 0) do
    if {:message_queue_len, 0} == :erlang.process_info(pid, :message_queue_len) do
      :ok
    else
      if time_elapsed > max_milli do
        {:error, "Timeout"}
      else
        time_to_sleep = 10
        Process.sleep(time_to_sleep)
        wait_for_mailbox_to_drain(pid, max_milli, time_elapsed + time_to_sleep)
      end
    end
  end
end
