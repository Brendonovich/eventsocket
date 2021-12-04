defmodule EventSocketWeb.Schema.User do
  use Absinthe.Schema.Notation

  alias EventSocketWeb.Resolvers

  object :user do
    field :id, :id
    field :display_name, :string

    field :subscriptions, list_of(:subscription) do
      resolve(&Resolvers.Subscription.user_subscriptions/3)
    end
  end
end
