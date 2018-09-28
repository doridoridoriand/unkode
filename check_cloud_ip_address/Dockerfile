FROM ruby:2.5.1

WORKDIR /usr/local/bin

COPY . .

RUN gem install bundler
RUN bundle install

ENTRYPOINT ruby bin/import_ip_address_range.rb
