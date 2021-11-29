defmodule EventSocketWeb.Schema.Subscription do
  use Absinthe.Schema.Notation

  object :event_subscription do
    field :id, :id
    field :type, :string
    field :condition, :map
  end
end
