defmodule EventSocket.Twitch.Auth do
  use GenServer

  alias EventSocket.{Env, Constants}

  defmodule State do
    defstruct app_access_token: "", jwt_public_key: ""
  end

  def app_access_token!(scopes \\ "") do
    response =
      HTTPoison.post!(
        "https://id.twitch.tv/oauth2/token",
        "",
        [],
        params: %{
          client_id: Env.twitch_client_id(),
          client_secret: Env.twitch_client_secret(),
          grant_type: "client_credentials",
          scopes: scopes
        }
      )

    case response do
      %HTTPoison.Response{status_code: 200, body: body} ->
        Jason.decode!(body)["access_token"]
    end
  end

  def app_access_token,
    do: GenServer.call(__MODULE__, :app_access_token)

  def keys! do
    case HTTPoison.get!("https://id.twitch.tv/oauth2/keys") do
      %HTTPoison.Response{status_code: 200, body: body} ->
        Jason.decode!(body)["keys"]
    end
  end

  def jwt_public_key,
    do: GenServer.call(__MODULE__, :jwt_public_key)

  def authorize_url(redirect_origin) do
    "https://id.twitch.tv/oauth2/authorize" <>
      "?client_id=#{Env.twitch_client_id()}" <>
      "&redirect_uri=#{redirect_origin}/auth/callback" <>
      "&response_type=code" <> "&scope=#{Enum.join(Constants.twitch_auth_scopes(), " ")}"
  end

  def token!(code, origin) do
    response =
      HTTPoison.post!(
        "https://id.twitch.tv/oauth2/token",
        "",
        [],
        params: %{
          client_id: Env.twitch_client_id(),
          client_secret: Env.twitch_client_secret(),
          grant_type: "authorization_code",
          redirect_uri: "#{origin}/auth/callback",
          code: code
        }
      )

    case response do
      %HTTPoison.Response{status_code: 200, body: body} ->
        Jason.decode!(body)
    end
  end

  def authorize_oauth_token!(code, origin) do
    token = token!(code, origin)

    {true, %{:fields => id_token}, _} = JOSE.JWT.verify(jwt_public_key(), token["id_token"])

    id_token
  end

  # GenServer handle_calls

  @impl true
  def handle_call(:app_access_token, _from, %State{} = state) do
    {:reply, state.app_access_token, state}
  end

  @impl true
  def handle_call(:jwt_public_key, _from, %State{} = state) do
    {:reply, state.jwt_public_key, state}
  end

  # GenServer stuff

  @impl true
  @spec init(State.t()) :: {:ok, State.t()}
  def init(_state) do
    {:ok,
     %State{
       app_access_token: app_access_token!(),
       jwt_public_key: keys!() |> Enum.at(0) |> JOSE.JWK.from_map()
     }}
  end

  def start_link(_) do
    GenServer.start_link(
      __MODULE__,
      %State{},
      name: __MODULE__
    )
  end

  @impl true
  def terminate(_reason, _state) do
    :ok
  end
end
