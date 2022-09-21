import { createQuery } from "@adeora/solid-query";
import { Navigate } from "@solidjs/router"
import { Match, Switch } from "solid-js"

import { createMeQuery, getAuthRedirect } from "../utils/api"

export default () => {
  const me = createMeQuery();
  const authRedirect = createQuery(() => ["redirectUrl"], getAuthRedirect)

  return (
    <Switch>
      <Match when={me.isError && !me.isLoading}>
        <div class="flex-1"/>
        <div class="flex flex-col items-center max-w-2xl mx-auto p-8 space-y-8 bg-gray-800 rounded-xl border-2 border-gray-700">
          <h1 class="text-5xl font-bold">EventSocket</h1>
          <p class="text-center">
            {"Welcome to EventSocket, a tool for connecting to Twitch's "}
            <a href="https://dev.twitch.tv/docs/eventsub" class="text-purple-400 underline">{"EventSub service"}</a>
            {" via WebSockets. To get started, login with Twitch below."}
          </p>
          <button disabled={authRedirect.isLoading} onClick={() => window.location.href = authRedirect.data?.data} class="py-2 px-4 bg-purple-600 disabled:bg-gray-500 text-white text-xl font-semibold rounded-lg">Login</button>
        </div>
        <div class="flex-1"/>
      </Match>
      <Match when={!me.isError && !me.isLoading}>
        <Navigate href="/subscriptions"/>
      </Match>
    </Switch>
  )
}
