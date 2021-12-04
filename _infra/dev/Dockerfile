FROM elixir:1.12-alpine

# Install build dependencies
RUN apk update && \
    apk upgrade --no-cache && \
    apk add --no-cache \
    build-base && \
    mix local.hex --force && \
    mix local.rebar --force 