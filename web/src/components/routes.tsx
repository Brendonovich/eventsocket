import { Route, useNavigate } from "react-location";
import AuthRoutes from "./Auth/routes";
import Subscriptions from "./Subscriptions";
import Settings from "./Settings";
import Events from "./Events";

const Redirect = ({ to }: { to: string }) => {
  useNavigate()({ to });
  return null;
};

export default [
  { path: "auth", children: AuthRoutes },
  { path: "subscriptions", element: <Subscriptions /> },
  { path: "settings", element: <Settings /> },
  { path: "events", element: <Events /> },
  {
    path: "/",
    element: <Redirect to="/subscriptions" />,
  },
] as Route[];
