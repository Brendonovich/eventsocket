# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     EventSocket.Repo.insert!(%EventSocket.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias EventSocket.Repo.Schema

EventSocket.Repo.insert!(%Schema.User{
  display_name: "Brendonovich",
  id: 53_168_490,
  api_key_hash: :erlang.phash2("0")
})
