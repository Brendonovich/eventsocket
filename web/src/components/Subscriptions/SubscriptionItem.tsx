import { createMutation } from "@adeora/solid-query";
import { Toggle } from "solid-headless";
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

const Subscription = (props: Props) => {
  const deleteMut = createMutation(
    async (id) => {
      const res = await deleteSubscription(id);
      return res.data;
    },
    {
      onMutate: async (id: string) => {
        const previousSubscriptions: any[] = queryClient.getQueryData([
          "subscriptions",
        ])!;

        const subscription = previousSubscriptions.find((sub) => sub.id === id);

        queryClient.setQueryData(
          ["subscriptions"],
          (d?: any[]) => d?.filter((s) => s !== subscription) || []
        );

        console.log({previousSubscriptions, subscription})

        return { previousSubscriptions, subscription };
      },
      onError: (_err, _id, context) => {
        queryClient.setQueryData(["subscriptions"], (d?: any[]) => [
          ...(d || []),
          context!.subscription,
        ]);
      },
      onSuccess: () => {},
    }
  );

  const createMut = createMutation(
    async (type) => {
      const res = await createSubscription(type);
      return res.data;
    },
    {
      onMutate: async (type: string) => {
        const previousSubscriptions: any[] = queryClient.getQueryData([
          "subscriptions",
        ])!;

        queryClient.setQueryData(["subscriptions"], (d?: any[]) => [
          ...(d ?? []),
          {
            type,
            id: type,
          },
        ]);

        console.log({previousSubscriptions})

        return { previousSubscriptions };
      },
      onError: (_err, _id, context) => {
        queryClient.setQueryData(
          ["subscriptions"],
          context?.previousSubscriptions
        );
      },
      onSuccess: (data, type) => {
        queryClient.setQueryData(["subscriptions"], (d?: any[]) => {
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

  const checked = () => !!props.id;
  const disabledVal = () => deleteMut.isLoading || createMut.isLoading || props.disabled

  return (
    <div class="bg-[#111] border border-gray-700 rounded-md p-4 flex justify-between items-start">
      <div class="-my-1">
        <p class="text-2xl">{props.subscription.name}</p>
        <p class="text-base text-gray-400">{props.subscription.type}</p>
      </div>
      <Toggle
        pressed={checked()}
        onChange={() => {
          if (checked() && props.id) deleteMut.mutateAsync(props.id, {});
          else createMut.mutateAsync(props.subscription.type);
        }}
        disabled={disabledVal()}
        class={clsx(
          checked() ? "bg-indigo-600" : "bg-gray-200",
          "relative inline-flex items-center h-6 rounded-full w-11 disabled:bg-gray-500 transition-colors"
        )}
      >
        <span
          class={clsx(
            checked() ? "translate-x-6" : " translate-x-1",
            "inline-block w-4 h-4 transform transition-transform bg-white rounded-full disabled:bg-gray-300"
          )}
        />
      </Toggle>
    </div>
  );
};

export default Subscription;
