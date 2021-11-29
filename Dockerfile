FROM elixir:1.12-alpine AS build

WORKDIR /app

RUN mix local.hex --force
RUN mix local.rebar --force

COPY ./mix.exs ./mix.lock ./
RUN mix deps.get

COPY ./config ./lib ./priv ./

RUN MIX_ENV=prod mix release

FROM alpine:3.15

WORKDIR /app
COPY --from=build app/_build/prod/rel/event_socket build

EXPOSE 4000

CMD ["./build/bin/event_socket"]