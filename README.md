# EventSocket

## A Websocket Proxy and Management Tool for Twitch's EventSub Service

EventSub is a great method for receiving events from Twitch, but it does not currently support WebSockets, making it difficult for streamers who just want to receive events for themselves to their own machines without configuring servers.

EventSocket provides a WebSocket server that forwards events from EventSub webhooks to any WebSocket client, as well as providing a UI for enabling EventSub subscriptions.

## How to Use

1. Login to [EventSocket](https://app.eventsocket.brendonovich.dev)
2. Go to the settings page and generate an API key. Store it somewhere safe, since it cannot be accessed again after leaving the settings page.
3. Using a WebSocket client, connect to `https://api.eventsocket.brendonovich.dev?api_key=YOUR_API_KEY`, replacing `YOUR_API_KEY` with the API key generated in step 2
4. Enable some subscriptions in the Events tab on the website
5. You should start receiving events through your socket!

## Protocol

Most messages resemble those documented in the [EventSub WebSockets RFC](https://discuss.dev.twitch.tv/t/rfc-0016-eventsub-websockets/32652), with all messages having `metadata` and `payload` fields.

### Event Notifications

Event notification messages are similar to EventSub events:

```json
{
  "metadata": {
    "message_id": "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXX",
    "message_timestamp": "2022-01-1T00:00:00Z",
    "message_type": "notification",
    "subscription_type": "channel.follow"
  },
  "payload": {
    // EventSub event data
    "event": {
      "broadcaster_user_id": "53168490",
      "broadcaster_user_login": "brendonovich",
      "broadcaster_user_name": "Brendonovich",
      "moderator_user_id": "53168490",
      "moderator_user_login": "brendonovich",
      "moderator_user_name": "Brendonovich",
      "user_id": "53168490",
      "user_login": "brendonovich",
      "user_name": "Brendonovich"
    },
    "subscription": {
      "type": "channel.follow"
    }
  }
}
```

Notice that there is no `condition` field in `payload.subscription`. Conditions are mostly used in EventSub to specify which user a subscription should receive events for, but since EventSocket already scopes the events you receive to your own user ID conditions are mostly redundant, and thus not used. This only affects the `channel.raid` subscription type, as `from_broadcaster_id` or `to_broadcaster_id` must be provided with EventSub. To account for this, EventSocket provides `channel.raid.give` and `channel.raid.receive` as subscription types.

`channel.raid.give` EventSub equivalent:

```json
{
  "subscription": {
    "type": "channel.raid",
    "condition": {
      "from_broadcaster_id": "your user id"
    }
  }
}
```

`channel.raid.receive` EventSub equivalent:

```json
{
  "subscription": {
    "type": "channel.raid",
    "condition": {
      "to_broadcaster_id": "your user id"
    }
  }
}
```

### Keepalive

Every 15 seconds, the server will send a keepalive message. If this message is not received in a 15-20 second interval, it is safe to assume that the socket is disconnected and you should reconnect.

```json
{
  "metadata": {
    "message_id": "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXX",
    "message_timestamp": "2022-01-1T00:00:00Z",
    "message_type": "websocket_keepalive"
  },
  "payload": {} // No data
}
```

### Reconnect

In the event that the EventSocket server you are connected to is about to shutdown (eg. during an update of the server), a reconnect message will be sent, after which you have 10 seconds to establish a new WebSocket connection before the old one is forcefully disconnected.

```json
{
  "metadata": {
    "message_id": "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXX",
    "message_timestamp": "2022-01-1T00:00:00Z",
    "message_type": "websocket_reconnect"
  },
  "payload": {} // No data
}
```

## Self Hosting

If you don't like the idea of all your twitch events passing through my server, create an application in the [Twitch Developer Console](https://dev.twitch.tv/console), and then pull and run the [EventSocket API docker image](https://github.com/Brendonovich/eventsocket/pkgs/container/eventsocket-api) with the following environment variables:

- `DATABASE_URL`: Full address to a Postgres database
- `SECRET_KEY_BASE`: A random string for use in encryption
- `TWITCH_CLIENT_ID`: Client ID of your Twitch application
- `TWITCH_CLIENT_SECRET`: Client Secret of your Twitch application
- `SELF_ORIGIN`: IP or domain name you will use to access the API, eg: `https://example.com`
- `WEB_ORIGIN`: IP or domain name you will use to access the frontend

To run the frontend, I would suggest forking this repo and using [Vercel](https://vercel.com/) to host your own version. Add the full URL to where you are hosting the API as the `VITE_API_URL` environment variable in your Vercel project's settings. Everything else should already be configured, since https://app.eventsocket.brendonovich.dev is hosted on Vercel too.
