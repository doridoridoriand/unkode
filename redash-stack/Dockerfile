FROM ruby:2.5.1
RUN gem install clickhouse

ARG CLICK_HOUSE_HOST
ARG CLICK_HOUSE_PORT

ENTRYPOINT ['/usr/local/bundle/bin/clickhouse', 'server', 'http://'${CLICK_HOUSE_HOST}:${CLICK_HOUSE_PORT}]
