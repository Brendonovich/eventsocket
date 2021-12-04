defmodule EventSocket.PubSub.Events.User do
  defmodule EventsubNotification do
    defstruct type: "",
              event: %{},
              condition: nil,
              id: ""
  end
end
