#!/usr/bin/env ruby
require 'unicorn'
require 'securerandom'
require 'cuba'
require 'cuba/safe'

$: << File.expand_path(File.join(['.']))
require 'app'

run Cuba
