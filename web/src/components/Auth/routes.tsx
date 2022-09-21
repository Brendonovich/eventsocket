import { RouteDefinition } from "@solidjs/router";
import { lazy } from "solid-js";

export const routes: RouteDefinition[] = [
  {
    path: "callback",
    element: lazy(() => import("./Callback")),
  },
];
