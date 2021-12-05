defmodule EventSocket.Events do
  alias EventSocket.Repo.Mutations
  alias EventSocket.PubSub.Events.User.EventsubNotification

  def create_from_pubsub(user_id, %EventsubNotification{} = pubsub_event) do
    Mutations.Events.create(%{
      user_id: user_id,
      id: pubsub_event.id,
      raw: pubsub_event
    })
  end
end
