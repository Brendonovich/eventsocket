defmodule EventSocketWeb.Router do
  use EventSocketWeb, :router

  import Phoenix.LiveDashboard.Router

  pipeline :api do
    plug Plug.Parsers,
      parsers: [:json],
      pass: ["*/*"],
      json_decoder: Phoenix.json_library()

    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug EventSocketWeb.Plugs.Auth
  end

  pipeline :admin_auth do
    plug EventSocketWeb.Plugs.AdminAuth
  end

  scope "/" do
    pipe_through :api

    scope "/eventsub", EventSocketWeb do
      post("/webhook", WebhookController, :handle_event)

      pipe_through :auth

      post("/subscriptions", EventSubController, :create_subscription)
      get("/subscriptions", EventSubController, :get_subscriptions)
      delete("/subscriptions", EventSubController, :delete_subscription)
    end

    scope "/auth", EventSocketWeb do
      ## OAuth handling
      get("/redirect", AuthController, :get_redirect_uri)
      post("/authorize", AuthController, :oauth_authorize)

      pipe_through :auth

      get("/me", AuthController, :me)
      post("/logout", AuthController, :logout)
      post("/generate_api_key", AuthController, :generate_api_key)
    end

    scope "/admin", EventSocketWeb do
      pipe_through :admin_auth

      delete("/subscriptions", AdminController, :delete_all_subscriptions)
      live_dashboard "/dashboard"
    end
  end
end
