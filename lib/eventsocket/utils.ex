defmodule EventSocket.Utils do
  def decode_body(res), do: res |> Map.get(:body) |> Jason.decode!()
end
