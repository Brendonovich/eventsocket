defmodule EventSocket.Utilities do
  def get_env(name), do: Application.get_env(:eventsocket, name)

  def decode_body(res), do: res |> Map.get(:body) |> Jason.decode!()
end
