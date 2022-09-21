defmodule EventSocket.Event do
  # alias EventSocket.Repo.Mutation
  # alias EventSocket.PubSub.Event.EventsubNotification

  @types [
    "channel.ban",
    "channel.channel_points_custom_reward.add",
    "channel.channel_points_custom_reward.remove",
    "channel.channel_points_custom_reward.update",
    "channel.channel_points_custom_reward_redemption.add",
    "channel.channel_points_custom_reward_redemption.update",
    "channel.cheer",
    "channel.follow",
    "channel.goal.begin",
    "channel.goal.end",
    "channel.goal.progress",
    "channel.hype_train.begin",
    "channel.hype_train.end",
    "channel.hype_train.progress",
    "channel.moderator.add",
    "channel.moderator.remove",
    "channel.poll.begin",
    "channel.poll.progress",
    "channel.poll.end",
    "channel.prediction.begin",
    "channel.prediction.end",
    "channel.prediction.lock",
    "channel.prediction.progress",
    "channel.raid.give",
    "channel.raid.receive",
    "channel.subscribe",
    "channel.subscription.end",
    "channel.subscription.gift",
    "channel.subscription.message",
    "channel.unban",
    "channel.update",
    "stream.online",
    "stream.offline",
    "user.update"
  ]

  # Database calls
  # def create_from_pubsub(user_id, %EventsubNotification{} = pubsub_event) do
  #   Mutation.Events.create(%{
  #     user_id: user_id,
  #     id: pubsub_event.id,
  #     raw: pubsub_event
  #   })
  # end

  # Coversion

  @spec to_twitch(String.t(), integer) :: nil | {String.t(), map}
  def to_twitch("channel.raid.give", user_id) do
    {"channel.raid",
     %{
       from_broadcaster_id: "#{user_id}"
     }}
  end

  def to_twitch("channel.raid.receive", user_id) do
    {"channel.raid",
     %{
       to_broadcaster_id: "#{user_id}"
     }}
  end

  def to_twitch(type, user_id) when type in @types do
    {type,
     %{
       broadcaster_user_id: "#{user_id}"
     }}
  end

  def to_twitch(_, _) do
    nil
  end

  def from_twitch("channel.raid", condition) do
    case condition do
      %{"from_broadcaster_id" => user_id} ->
        {"channel.raid.give", user_id}

      %{"to_broadcaster_id" => user_id} ->
        {"channel.raid.receive", user_id}
    end
  end

  def from_twitch(type, condition) when type in @types do
    {type, condition["broadcaster_user_id"]}
  end

  def from_twitch(_, _) do
    nil
  end
end
