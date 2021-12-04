defmodule EventSocket.Webhook.Event do
  alias EventSocket.Webhook.Event.Headers

  defstruct headers: %Headers{}, body: %{}

  def new(headers, body) do
    %__MODULE__{
      headers: Headers.new(headers),
      body: body
    }
  end
end
