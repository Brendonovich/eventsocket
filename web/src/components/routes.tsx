import { RouteDefinition } from "@solidjs/router";
import { lazy } from "solid-js";

import { routes as AuthRoutes } from "./Auth/routes";

export const routes: RouteDefinition[] = [
  {
    path: "/auth",
    children: AuthRoutes
  },
  {
    path: "/subscriptions",
    component: lazy(() => import("./Subscriptions"))
  },
  {
    path: "/settings",
    component: lazy(() => import("./Settings"))
  },
  {
    path: "/",
    component: lazy(() => import("./")),
  },
];
