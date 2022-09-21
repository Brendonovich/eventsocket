/* @refresh reload */
import { render } from "solid-js/web";
import { QueryClientProvider } from "@adeora/solid-query";
import { Router } from "@solidjs/router";

import "./index.css";
import { App } from "./App";
import { queryClient } from "./utils/api";

render(
  () => (
    <QueryClientProvider client={queryClient}>
      <Router>
        <App />
      </Router>
    </QueryClientProvider>
  ),
  document.getElementById("root") as HTMLElement
);
