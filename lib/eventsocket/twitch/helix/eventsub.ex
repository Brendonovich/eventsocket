defmodule EventSocket.Twitch.Helix.EventSub do
  alias EventSocket.{Twitch.Helix, Env}

  @spec create_subscription!(String.t(), map()) :: any
  def create_subscription!(type, condition) do
    Helix.post!("eventsub/subscriptions", %{
      "type" => type,
      "condition" => condition,
      "version" => 1,
      "transport" => %{
        "method" => "webhook",
        "callback" => "#{Env.callback_origin()}/eventsub/webhook",
        "secret" => Env.secret_key_base()
      }
    })
  end

  def delete_subscription!(id), do: Helix.delete!("eventsub/subscriptions", %{"id" => id})

  def get_subscriptions!(cursor \\ nil) do
    Helix.get!(
      "eventsub/subscriptions#{if cursor != nil do
        "?after=#{cursor}"
      else
        ""
      end}"
    )
  end
end
