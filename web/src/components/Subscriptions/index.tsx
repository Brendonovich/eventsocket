import { useState } from "react";
import { useQuery } from "react-query";

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
    type: "channel.raid",
    condition: { direction: "to" },
  },
  {
    name: "Raid Given",
    type: "channel.raid",
    condition: {
      direction: "from",
    },
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

const Subscriptions = () => {
  const [search, setSearch] = useState("");

  const { data, isLoading } = useQuery("subscriptions", async () => {
    const res = await getSubscriptions();
    return res.data;
  });

  let lowercaseSearch = search.toLowerCase();

  return (
    <div className="overflow-y-hidden flex-1">
      <div className="py-2 overflow-y-auto h-full px-2">
        <div className="flex flex-col space-y-2 w-full max-w-3xl mx-auto">
          <input
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            placeholder="Search Subscriptions"
            className="bg-gray-600 py-2 px-4 text-lg rounded-lg focus:outline-none focus:ring-indigo-600 ring-2 ring-transparent"
          />
          {ALL_SUBSCRIPTIONS.filter(
            (s) =>
              s.name.toLowerCase().includes(lowercaseSearch) ||
              s.type.toLowerCase().includes(lowercaseSearch)
          ).map((s) => {
            const matchingSubscription = data?.find(
              (sub) => sub.type === s.type
            );

            return (
              <SubscriptionItem
                subscription={s}
                id={matchingSubscription?.id}
                disabled={isLoading}
                key={s.type + JSON.stringify(s.condition)}
              />
            );
          })}
        </div>
      </div>
    </div>
  );
};

export default Subscriptions;
