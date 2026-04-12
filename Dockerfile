# docker build -t sensors .
# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.4.8

FROM --platform=linux/amd64 ruby:$RUBY_VERSION-alpine

ARG build_version=0.0.0
ENV BUILD_VERSION $build_version

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

RUN apk update \
  && apk add --no-cache --virtual .build-deps build-base libpq-dev yaml-dev pkgconfig

RUN apk add --no-cache tzdata

RUN mkdir /sensors
WORKDIR /sensors
COPY . /sensors/

RUN gem update --system \
  && bundle config set --local without 'development test' \
  && bundle install

RUN apk del .build-deps;

# Run and own only the runtime files as a non-root user for security
RUN adduser -D sensors \
    && chown -R sensors:sensors /sensors
USER sensors:sensors

# Entrypoint prepares the database.
ENTRYPOINT ["/sensors/bin/docker-entrypoint"]
