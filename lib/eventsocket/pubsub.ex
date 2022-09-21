defmodule EventSocket.PubSub do
  def subscribe(topic) do
    Phoenix.PubSub.subscribe(EventSocket.PubSub, topic)
  end

  def subscribe_user_events(user_id) do
    subscribe("user_events:#{user_id}")
  end

  def broadcast!(topic, message) do
    Phoenix.PubSub.broadcast!(EventSocket.PubSub, topic, message)
  end

  def broadcast_user_event!(user_id, event) do
    broadcast!("user_events:#{user_id}", event)
  end
end

defmodule EventSocket.PubSub.Event.EventsubNotification do
  defstruct type: "",
            event: %{},
            id: ""
end
