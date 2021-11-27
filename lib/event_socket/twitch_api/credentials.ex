defmodule EventSocket.TwitchAPI.Credentials do
  use GenServer

  alias EventSocket.TwitchAPI.Auth

  defmodule State do
    defstruct app_access_token: ""
  end

  @impl true
  @spec init(State.t()) :: {:ok, State.t()}
  def init(state) do
    {:ok, access_token} = Auth.request_app_access_token()
    {:ok, %State{state | app_access_token: access_token}}
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

  def get_app_access_token, do: GenServer.call(TwitchAPI.Credentials, :get_app_access_token)
end
