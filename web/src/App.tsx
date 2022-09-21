import { useMatch, useRoutes } from "@solidjs/router";
import { Show } from "solid-js";

import { createMeQuery } from "./utils/api";
import { NavBar } from "./components/NavBar";
import { routes } from "./components/routes";

export const App = () => {
  const Routes = useRoutes(routes)

  const isAuthRoute = useMatch(() => "auth/*");
  const isRoot = useMatch(() => "/")

  const me = createMeQuery({ enabled: !isAuthRoute() });

  const showRoutes = () => isRoot() || isAuthRoute() || !me.isLoading;
  const isNavBarRoute = () => !(isRoot() || isAuthRoute())

  return (
    <div class="bg-black w-screen h-screen text-white flex flex-col">
      <Show when={showRoutes()} fallback={null}>
        <Show when={!me.isLoading && isNavBarRoute()}>
          <NavBar />
        </Show>
        <Routes/>
      </Show>
    </div>
  );
};
