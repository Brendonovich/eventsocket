# STEP 1 - BUILD RELEASE 
FROM elixir:1.12-alpine AS deps-getter

RUN mkdir /app
WORKDIR /app

# Install build dependencies
RUN apk update && \
    apk upgrade --no-cache && \
    apk add --no-cache \
    build-base && \
    mix local.hex --force && \
    mix local.rebar --force 

ENV MIX_ENV=prod
RUN mkdir \ 
    /app/_build/ \
    /app/config/ \
    /app/lib/ \
    /app/priv/ \ 
    /app/deps/ \
    /app/rel/

# install deps and compile deps
COPY mix.exs /app/mix.exs
COPY mix.lock /app/mix.lock
RUN mix do deps.get --only $MIX_ENV, deps.compile
RUN mix compile

################################################################################
# STEP 3 - RELEASE BUILDER
FROM elixir:1.12-alpine  AS release-builder

ENV MIX_ENV=prod

RUN mkdir /app
WORKDIR /app

# need to install deps again to run mix phx.digest
RUN apk update && \
    apk upgrade --no-cache && \
    apk add --no-cache \
    git \
    build-base && \
    mix local.rebar --force && \
    mix local.hex --force

# copy elixir deps
COPY --from=deps-getter /app /app

# copy config, priv and release directories
COPY config /app/config
COPY priv /app/priv

# copy application code
COPY lib /app/lib

# create release
RUN mkdir -p /opt/built &&\
    mix release &&\
    cp -r _build/prod/rel/eventsocket /opt/built

################################################################################
## STEP 4 - FINAL
FROM alpine:3.11.3

ENV MIX_ENV=prod

RUN apk upgrade --no-cache && \
    apk add --no-cache bash openssl libgcc libstdc++ ncurses-libs

COPY --from=release-builder /opt/built /app
WORKDIR /app

EXPOSE 4000

CMD ["/app/eventsocket/bin/eventsocket", "start"]