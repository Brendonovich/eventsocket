defmodule EventSocket.Repo do
  use Ecto.Repo,
    otp_app: :eventsocket,
    adapter: Ecto.Adapters.Postgres
end
