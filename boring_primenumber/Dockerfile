FROM ruby:2.6.5

RUN gem install cuba unicorn unicorn-worker-killer

COPY . .
CMD ruby exec.rb 10000