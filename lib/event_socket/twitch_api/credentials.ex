defmodule EventSocket.TwitchAPI.Credentials do
  use GenServer

  alias EventSocket.TwitchAPI.Auth

  defmodule State do
    defstruct app_access_token: "", jwt_public_key: ""
  end

  @impl true
  @spec init(State.t()) :: {:ok, State.t()}
  def init(_state) do
    {:ok, access_token} = Auth.request_app_access_token()
    {:ok, key} = Auth.get_jwt_public_key()
    {:ok, %State{app_access_token: access_token, jwt_public_key: key}}
  end

  def start_link(_) do
    GenServer.start_link(
      __MODULE__,
      %State{},
      name: TwitchAPI.Credentials
    )
  end

  @impl true
  def handle_call(:get_app_access_token, _from, state) do
    {:reply, state.app_access_token, state}
  end

  @impl true
  def handle_call(:get_jwt_public_key, _from, state) do
    {:reply, state.jwt_public_key, state}
  end

  def get_app_access_token, do: GenServer.call(TwitchAPI.Credentials, :get_app_access_token)
  def get_jwt_public_key, do: GenServer.call(TwitchAPI.Credentials, :get_jwt_public_key) |> JOSE.JWK.from_map()
end
