defmodule EventSocketWeb.Resolvers.Subscription do
  alias EventSocket.{Subscriptions, Constants}

  def user_subscriptions(user, args, _resolution) do
    {:ok,
     Subscriptions.get_for_user(user.id)
     |> Enum.filter(fn s -> s.status == "enabled" end)}
  end
end
