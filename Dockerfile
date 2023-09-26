# docker build -t sensors .

FROM --platform=linux/amd64 ruby:3.2.2-alpine

RUN apk update \
    && apk add --no-cache libpq-dev \
    && apk add --no-cache --virtual .build-deps build-base

RUN mkdir /sensors
WORKDIR /sensors
COPY . /sensors/
RUN bundle install

RUN apk del .build-deps;

COPY docker/docker-entrypoint.sh /usr/local/bin/docker-entrypoint

RUN chmod +x /usr/local/bin/docker-entrypoint

ENV AWS_REGION "eu-west-2"

RUN adduser -D sensors \
  && chown -R sensors:sensors /sensors

USER sensors

ENTRYPOINT ["docker-entrypoint"]
