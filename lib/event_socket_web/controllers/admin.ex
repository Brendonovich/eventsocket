defmodule EventSocketWeb.AdminController do
  use EventSocketWeb, :controller

  alias EventSocket.Subscriptions
  alias EventSocket.Utilities
  alias EventSocket.TwitchAPI.Helix.EventSub

  defp delete_all_subscriptions_impl(cursor \\ nil) do
    %{"data" => subscriptions, "pagination" => pagination} =
      EventSub.get_subscriptions(cursor) |> elem(1) |> Utilities.decode_body()

    count = length(subscriptions)
    cursor = pagination["cursor"]

    Enum.map(subscriptions, fn subscription ->
      Subscriptions.delete_subscription(subscription["id"])
    end)

    if cursor != nil do
      count + delete_all_subscriptions_impl(cursor)
    else
      count
    end
  end

  def delete_all_subscriptions(conn, _data) do
    count = delete_all_subscriptions_impl()

    conn |> send_resp(200, "Deleted #{count} subscriptions")
  end
end
