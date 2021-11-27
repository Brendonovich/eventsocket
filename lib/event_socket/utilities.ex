defmodule EventSocket.Utilities do
  def get_env(name), do: Application.get_env(:event_socket, name)

  def decode_body(res), do: res |> Map.get(:body) |> Jason.decode!()
end
