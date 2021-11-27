defmodule EventSocket.Conditions do
  defp ok(%{} = args), do: {:ok, args}
  defp err(error), do: {:error, error}

  defp default(user_id),
    do:
      ok(%{
        "broadcaster_user_id" => user_id
      })

  def construct("channel.ban", user_id, _values), do: default(user_id)

  def construct("channel.channel_points_custom_reward.add", user_id, _values),
    do: default(user_id)

  def construct("channel.channel_points_custom_reward.remove", user_id, %{
        "reward_id" => reward_id
      }),
      do:
        ok(%{
          "broadcaster_user_id" => user_id,
          "reward_id" => reward_id
        })

  def construct("channel.channel_points_custom_reward.update", user_id, %{
        "reward_id" => reward_id
      }),
      do:
        ok(%{
          "broadcaster_user_id" => user_id,
          "reward_id" => reward_id
        })

  def construct("channel.channel_points_custom_reward_redemption.add", user_id, %{
        "reward_id" => reward_id
      }),
      do:
        ok(%{
          "broadcaster_user_id" => user_id,
          "reward_id" => reward_id
        })

  def construct("channel.channel_points_custom_reward_redemption.update", user_id, %{
        "reward_id" => reward_id
      }),
      do:
        ok(%{
          "broadcaster_user_id" => user_id,
          "reward_id" => reward_id
        })

  def construct("channel.cheer", user_id, _values), do: default(user_id)
  def construct("channel.follow", user_id, _values), do: default(user_id)
  def construct("channel.goal.begin", user_id, _values), do: default(user_id)
  def construct("channel.goal.end", user_id, _values), do: default(user_id)
  def construct("channel.goal.progress", user_id, _values), do: default(user_id)
  def construct("channel.hype_train.begin", user_id, _values), do: default(user_id)
  def construct("channel.hype_train.end", user_id, _values), do: default(user_id)
  def construct("channel.hype_train.progress", user_id, _values), do: default(user_id)
  def construct("channel.moderator.add", user_id, _values), do: default(user_id)
  def construct("channel.moderator.remove", user_id, _values), do: default(user_id)
  def construct("channel.poll.begin", user_id, _values), do: default(user_id)
  def construct("channel.poll.progress", user_id, _values), do: default(user_id)
  def construct("channel.poll.end", user_id, _values), do: default(user_id)
  def construct("channel.prediction.begin", user_id, _values), do: default(user_id)
  def construct("channel.prediction.end", user_id, _values), do: default(user_id)
  def construct("channel.prediction.lock", user_id, _values), do: default(user_id)
  def construct("channel.prediction.progress", user_id, _values), do: default(user_id)

  def construct("channel.raid", user_id, _values = %{"mode" => "from"}),
    do:
      ok(%{
        "from_broadcaster_user_id" => user_id
      })

  def construct("channel.raid", user_id, _values = %{"mode" => "to"}),
    do:
      ok(%{
        "to_broadcaster_user_id" => user_id
      })

  def construct("channel.raid", _user_id, _values),
    do: err("channel.raid requires 'mode' to be either 'from' or 'to")

  def construct("channel.subscribe", user_id, _values), do: default(user_id)
  def construct("channel.subscription.end", user_id, _values), do: default(user_id)
  def construct("channel.subscription.gift", user_id, _values), do: default(user_id)
  def construct("channel.subscription.message", user_id, _values), do: default(user_id)
  def construct("channel.unban", user_id, _values), do: default(user_id)
  def construct("channel.update", user_id, _values), do: default(user_id)
  def construct("stream.online", user_id, _values), do: default(user_id)
  def construct("stream.offline", user_id, _values), do: default(user_id)
  def construct("user.update", user_id, _values), do: default(user_id)

  def construct(_type, _user_id, _values), do: err("Invalid topic provided")

  def deconstruct(%{"broadcaster_user_id" => user_id}), do: {:ok, user_id, %{}}

  def deconstruct(%{"from_broadcaster_user_id" => user_id}),
    do:
      {:ok, user_id,
       %{
         "mode" => "from"
       }}

  def deconstruct(%{"to_broadcaster_user_id" => user_id}),
    do:
      {:ok, user_id,
       %{
         "mode" => "from"
       }}

  def deconstruct(_), do: {:error, :invalid_deconstruct_input}
end
