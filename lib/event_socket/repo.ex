defmodule EventSocket.Repo do
  use Ecto.Repo,
    otp_app: :event_socket,
    adapter: Ecto.Adapters.Postgres
end
