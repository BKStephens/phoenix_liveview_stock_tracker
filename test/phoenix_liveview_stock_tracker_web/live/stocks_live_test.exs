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

    assert render(view) =~ "<div class=\"stock-details\">TSLA $246.68</div>"
  end

  test "user sees error when hitting Alpha Vantage rate limit while searching", %{conn: conn} do
    {:ok, view, _html} =
      conn
      |> get("/")
      |> live

    view
    |> form(".autocomplete-search-form", q: "RATELIMIT")
    |> render_change()

    :ok = TestHelper.wait_for_mailbox_to_drain(view.pid)

    assert render(view) =~
             "<div class=\"error\">Something went wrong. Please try again in a minute.</div>"
  end

  test "user sees error when hitting Alpha Vantage rate limit while loading details", %{
    conn: conn
  } do
    {:ok, view, _html} =
      conn
      |> get("/")
      |> live

    view
    |> form(".autocomplete-search-form", q: "RATELIMIT")
    |> render_submit()

    :ok = TestHelper.wait_for_mailbox_to_drain(view.pid)

    assert render(view) =~
             "<div class=\"error\">Something went wrong. Please make sure you are passing in a valid stock symbol or try again in a minute.</div>"
  end
end
