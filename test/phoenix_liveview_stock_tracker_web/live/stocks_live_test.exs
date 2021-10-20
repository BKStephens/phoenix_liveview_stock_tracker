defmodule PhoenixLiveviewStockTrackerWeb.StocksLiveTest do
  use PhoenixLiveviewStockTrackerWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  setup do
    Mox.stub_with(
      PhoenixLiveviewStockTracker.AlphaVantageApiClientMock,
      PhoenixLiveviewStockTracker.AlphaVantageApiClientStub
    )

    :ok
  end

  test "user can search for Tesla and select", %{conn: conn} do
    {:ok, view, _html} =
      conn
      |> get("/")
      |> live

    rendered =
      view
      |> form(".autocomplete-search-form", q: "Tesl")
      |> render_change()

    assert rendered =~ "<option value=\"TSLA\">TSLA Tesla Inc</option>"

    view
    |> form(".autocomplete-search-form", q: "TSLA")
    |> render_submit()

    :ok = TestHelper.wait_for_mailbox_to_drain(view.pid)

    assert render(view) =~ "<pre>TSLA 246.6800</pre>"
  end
end
