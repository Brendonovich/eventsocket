import { useMutation } from "react-query";
import { Switch } from "@headlessui/react";
import clsx from "clsx";

import {
  createSubscription,
  deleteSubscription,
  queryClient,
} from "../../utils/api";

export interface Subscription {
  name: string;
  type: string;
}

interface Props {
  subscription: Subscription;
  id?: string;
  disabled?: boolean;
}

const Subscription = ({ subscription, id, disabled }: Props) => {
  const deleteMutation = useMutation(
    async (id) => {
      const res = await deleteSubscription(id);
      return res.data;
    },
    {
      onMutate: async (id: string) => {
        const previousSubscriptions: any[] =
          queryClient.getQueryData("subscriptions")!;

        const subscription = previousSubscriptions.find((sub) => sub.id === id);

        queryClient.setQueryData(
          "subscriptions",
          (d?: any[]) => d?.filter((s) => s !== subscription) || []
        );

        return { previousSubscriptions, subscription };
      },
      onError: (_err, _id, context) => {
        queryClient.setQueryData("subscriptions", (d?: any[]) => [
          ...(d || []),
          context!.subscription,
        ]);
      },
      onSuccess: () => {},
    }
  );

  const createMutation = useMutation(
    async (type) => {
      const res = await createSubscription(type);
      return res.data;
    },
    {
      onMutate: async (type: string) => {
        const previousSubscriptions: any[] =
          queryClient.getQueryData("subscriptions")!;

        queryClient.setQueryData("subscriptions", (d?: any[]) => [
          ...(d ?? []),
          {
            type,
            id: type,
          },
        ]);

        return { previousSubscriptions };
      },
      onError: (_err, _id, context) => {
        queryClient.setQueryData(
          "subscriptions",
          context?.previousSubscriptions
        );
      },
      onSuccess: (data, type) => {
        queryClient.setQueryData("subscriptions", (d?: any[]) => {
          let newSubscriptions = d ? [...d] : [];

          newSubscriptions = newSubscriptions.map((s) => {
            if (s.id === type) return { ...s, id: data.id };

            return s;
          });

          return newSubscriptions;
        });
      },
    }
  );

  const checked = !!id;

  return (
    <div
      key={subscription.type}
      className="bg-[#111] border border-gray-700 rounded-md p-4 flex justify-between items-start"
    >
      <div className="-my-1">
        <p className="text-2xl">{subscription.name}</p>
        <p className="text-base text-gray-400">{subscription.type}</p>
      </div>
      <Switch
        checked={checked}
        onChange={() => {
          if (checked) deleteMutation.mutateAsync(id, {});
          else createMutation.mutateAsync(subscription.type);
        }}
        disabled={
          deleteMutation.isLoading || createMutation.isLoading || disabled
        }
        className={clsx(
          checked ? "bg-indigo-600" : "bg-gray-200",
          "relative inline-flex items-center h-6 rounded-full w-11 disabled:bg-gray-500 transition-colors"
        )}
      >
        <span
          className={clsx(
            checked ? "translate-x-6" : " translate-x-1",
            "inline-block w-4 h-4 transform transition-transform bg-white rounded-full disabled:bg-gray-300"
          )}
        />
      </Switch>
    </div>
  );
};

export default Subscription;
