defmodule EventSocketWeb.Router do
  use EventSocketWeb, :router

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

  scope "/api", EventSocketWeb do
    pipe_through :api
  end

  scope "/" do
    pipe_through :api

    scope "/eventsub", EventSocketWeb do
      post "/webhook", WebhookController, :handle_event

      pipe_through :auth

      post "/subscriptions", EventSubController, :create_subscription
      get "/subscriptions", EventSubController, :get_subscriptions
      delete "/subscriptions", EventSubController, :delete_subscription
    end

    scope "/auth", EventSocketWeb do
      ## OAuth handling
      get "/redirect", AuthController, :get_redirect_uri
      post "/authorize", AuthController, :oauth_authorize

      pipe_through :auth

      get "/me", AuthController, :me
      post "/logout", AuthController, :logout
      post "/generate_api_key", AuthController, :generate_api_key
    end

    scope "/admin", EventSocketWeb do
      pipe_through :admin_auth

      delete "/subscriptions", AdminController, :delete_all_subscriptions
    end
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: EventSocketWeb.Telemetry
    end
  end
end
