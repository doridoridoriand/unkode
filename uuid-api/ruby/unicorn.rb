#!/usr/bin/env ruby
require 'unicorn'
require 'unicorn/worker_killer'
require 'securerandom'
require 'cuba'
require 'cuba/safe'

worker_processes 16
working_directory __dir__

timeout 10
listen 3000

pid "#{__dir__}/unicorn.pid"

# env=localのときは全て標準出力に流す
stderr_path "#{__dir__}/logs/unicorn/stderr.log" unless ENV['RACK_ENV'] == 'local'
stdout_path "#{__dir__}/logs/unicorn/stdout.log" unless ENV['RACK_ENV'] == 'local'

preload_app true
