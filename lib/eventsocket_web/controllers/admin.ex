defmodule EventSocketWeb.AdminController do
  use EventSocketWeb, :controller

  alias EventSocket.Subscription
  alias EventSocket.Utils
  alias EventSocket.Twitch.Helix.EventSub

  defp delete_all_subscriptions_impl(cursor \\ nil) do
    %{"data" => subscriptions, "pagination" => pagination} =
      EventSub.get_subscriptions!(cursor) |> Utils.decode_body()

    count = length(subscriptions)
    cursor = pagination["cursor"]

    Enum.map(subscriptions, fn subscription ->
      Subscription.delete_subscription!(subscription["id"])
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
