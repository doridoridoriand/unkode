FROM ruby:2.5.1
RUN gem install clickhouse

ENV CLICK_HOUSE_HOST 127.0.0.1
ENV CLICK_HOUSE_PORT 8123

ENTRYPOINT ['/docker-entrypoint.sh']
