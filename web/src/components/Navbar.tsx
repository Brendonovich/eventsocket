import { createQuery } from "@adeora/solid-query";
import { Link, useMatch } from "@solidjs/router";
import { JSXElement } from "solid-js";
import { For } from "solid-js/web";
import clsx from "clsx";

export const NavBarRoutes = [
  {
    href: "/subscriptions",
    text: "Subscriptions",
  },
  // {
  //   href: "/events",
  //   text: "Events",
  // },
  {
    href: "/settings",
    text: "Settings",
  },
];

const NavBarItem = (props: { href: string; children: JSXElement }) => {
  const match = useMatch(() => props.href);

  return (
    <div
      class={clsx(
        "font-medium border-b-2 border-transparent py-4 transition-colors",
        match() && "border-white"
      )}
    >
      <Link class="bg-opacity-40 p-2 rounded-md" {...props} />
    </div>
  );
};

export const NavBar = () => {
  const me = createQuery<any>(() => ["me"]);

  return (
    <div class="w-full flex flex-row bg-gray-900 border-b border-gray-700">
      <div class="flex-1 flex items-center px-4">
        <span class="font-bold text-2xl">EventSocket</span>
      </div>
      <div class="space-x-4 flex flex-row text-lg">
        <For each={NavBarRoutes}>
          {(r) => <NavBarItem href={r.href}>{r.text}</NavBarItem>}
        </For>
      </div>
      <div class="flex items-center justify-end px-4 space-x-4 flex-1">
        <span class="text-xl">{me!.data.display_name}</span>
      </div>
    </div>
  );
};
