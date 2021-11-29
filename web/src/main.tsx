import React from "react";
import ReactDOM from "react-dom";
import "./index.css";
import { Outlet, ReactLocation, Router } from "react-location";
import routes from "./components/routes";
import { QueryClientProvider } from "react-query";
import { queryClient } from "./utils/api";
import App from "./App";

const location = new ReactLocation();

console.log(location);

ReactDOM.render(
  <React.StrictMode>
    <QueryClientProvider client={queryClient}>
      <Router location={location} routes={routes}>
        <App/>
      </Router>
    </QueryClientProvider>
  </React.StrictMode>,
  document.getElementById("root")
);
