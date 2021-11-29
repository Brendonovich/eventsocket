import { ReactNode } from "react";
import { Link, useMatchRoute } from "react-location";
import clsx from "clsx";
import { useMutation, useQuery } from "react-query";
import { logout } from "../utils/api";

const NavbarRoutes = [
  {
    path: "/subscriptions",
    text: "Subscriptions",
  },
  {
    path: "/events",
    text: "Events",
  },
  {
    path: "/settings",
    text: "Settings",
  },
];

const NavbarItem = (props: { to: string; children: ReactNode }) => {
  const matchRoute = useMatchRoute();

  const match = matchRoute({ to: props.to });

  return (
    <div
      className={clsx(
        "font-medium border-b border-transparent px-2 py-3",
        match && "border-white"
      )}
    >
      <Link {...props} />
    </div>
  );
};

const Navbar = () => {
  const { data: me } = useQuery<{ display_name: string }>("me");

  return (
    <div className="w-full flex flex-row bg-gray-900">
      <div className="flex-1 flex items-center px-4">
        <span className="font-bold text-2xl">EventSocket</span>
      </div>
      <div className="space-x-4 flex flex-row bg-gray-900 text-lg">
        {NavbarRoutes.map((r) => (
          <NavbarItem to={r.path} key={r.path}>
            {r.text}
          </NavbarItem>
        ))}
      </div>
      <div className="flex items-center justify-end px-4 space-x-4 flex-1">
        <span className="text-xl">{me!.display_name}</span>
      </div>
    </div>
  );
};

export default Navbar;
