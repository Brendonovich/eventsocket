import { createQuery } from "@adeora/solid-query";
import { createSignal, For } from "solid-js";
import { getSubscriptions } from "../../utils/api";
import SubscriptionItem, { Subscription } from "./SubscriptionItem";

const ALL_SUBSCRIPTIONS: Subscription[] = [
  { name: "Follow", type: "channel.follow" },
  { name: "Cheer", type: "channel.cheer" },
  { name: "New Subscription", type: "channel.subscribe" },
  { name: "Subscription Message", type: "channel.subscription.message" },
  { name: "Subscription Gift", type: "channel.subscription.gift" },
  { name: "Subscription End", type: "channel.subscription.end" },
  {
    name: "Reward Redemption Add",
    type: "channel.channel_points_custom_reward_redemption.add",
  },
  {
    name: "Reward Redemption Update",
    type: "channel.channel_points_custom_reward_redemption.update",
  },
  {
    name: "Reward Add",
    type: "channel.channel_points_custom_reward.add",
  },
  {
    name: "Reward Update",
    type: "channel.channel_points_custom_reward.update",
  },
  {
    name: "Reward Remove",
    type: "channel.channel_points_custom_reward.remove",
  },
  {
    name: "Raid Received",
    type: "channel.raid.receive",
  },
  {
    name: "Raid Given",
    type: "channel.raid.give",
  },
  { name: "Hype Train Begin", type: "channel.hype_train.begin" },
  { name: "Hype Train Progress", type: "channel.hype_train.progress" },
  { name: "Hype Train End", type: "channel.hype_train.end" },
  { name: "Goal Begin", type: "channel.goal.begin" },
  { name: "Goal Progress", type: "channel.goal.progress" },
  { name: "Goal End", type: "channel.goal.end" },
  { name: "Poll Begin", type: "channel.poll.begin" },
  { name: "Poll Progress", type: "channel.poll.progress" },
  { name: "Poll End", type: "channel.poll.end" },
  { name: "Prediction Begin", type: "channel.prediction.begin" },
  { name: "Prediction Progress", type: "channel.prediction.progress" },
  { name: "Prediction Lock", type: "channel.prediction.lock" },
  { name: "Prediction End", type: "channel.prediction.end" },
  { name: "Stream Online", type: "stream.online" },
  { name: "Stream Offline", type: "stream.offline" },
  { name: "Moderator Added", type: "channel.moderator.add" },
  { name: "Moderator Removed", type: "channel.moderator.remove" },
  { name: "User Banned", type: "channel.ban" },
  { name: "User Unbanned", type: "channel.unban" },
  { name: "Account Updated", type: "user.update" },
  { name: "Channel Updated", type: "channel.update" },
];

export default () => {
  const [search, setSearch] = createSignal("");

  const subscriptions = createQuery(() => ["subscriptions"], () => getSubscriptions().then(r => r.data));

  const lowercaseSearch = () => search().toLowerCase();

  return (
    <div class="overflow-y-hidden flex-1">
      <div class="py-2 overflow-y-auto h-full px-2">
        <div class="flex flex-col space-y-2 w-full max-w-3xl mx-auto">
          <input
            value={search()}
            onInput={(e) => setSearch((e.target as any).value)}
            placeholder="Search Subscriptions"
            class="bg-gray-600 py-2 px-4 text-lg rounded-lg focus:outline-none focus:ring-indigo-600 ring-2 ring-transparent"
          />
          <For each={ALL_SUBSCRIPTIONS.filter(
            (s) =>
              s.name.toLowerCase().includes(lowercaseSearch()) ||
              s.type.toLowerCase().includes(lowercaseSearch())
          )}>
            {(s) => {
              const matchingSubscription = () => subscriptions.data?.find(
                (sub) => sub.type === s.type
              );

              return (
                <SubscriptionItem
                  subscription={s}
                  id={matchingSubscription()?.id}
                  disabled={subscriptions.isLoading}
                />
              );
            }}
          </For>
        </div>
      </div>
    </div>
  );
};
