defmodule EventSocket.PubSub do
  def subscribe(topic) do
    Phoenix.PubSub.subscribe(EventSocket.PubSub, topic)
  end

  def broadcast(topic, message) do
    Phoenix.PubSub.broadcast!(EventSocket.PubSub, topic, message)
  end
end
