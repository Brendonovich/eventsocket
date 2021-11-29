FROM elixir:1.12-alpine AS build

WORKDIR /app

RUN mix local.hex --force && \
    mix local.rebar --force
    
ENV MIX_ENV=prod

COPY ./mix.exs ./mix.lock ./
RUN mix deps.get

COPY ./config ./lib ./priv ./

RUN mix release

FROM alpine:3.15

RUN apk upgrade --no-cache && \
    apk add --no-cache bash openssl libgcc libstdc++ ncurses-libs

WORKDIR /app
COPY --from=build app/_build/prod/rel/eventsocket build

EXPOSE 4000

CMD ["./build/bin/eventsocket", "start"]