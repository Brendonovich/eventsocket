defmodule EventSocket.Constants do
  def twitch_auth_scopes do
    [
      "channel:moderate",
      "channel:read:redemptions",
      "bits:read",
      "channel:read:goals",
      "channel:read:hype_train",
      "moderation:read",
      "channel:read:polls",
      "channel:read:predictions",
      "channel:read:subscriptions",
      "openid"
    ]
  end

  def webhook_verification_failed, do: "webhook_callback_verification_failed"
  def webhook_user_removed, do: "user_removed"
  def webhook_enabled, do: "enabled"
end
