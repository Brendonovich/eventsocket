defmodule EventSocket.PubSub.Events.User do
  defmodule EventsubNotification do
    defstruct type: "",
              event: %{},
              id: ""
  end
end
