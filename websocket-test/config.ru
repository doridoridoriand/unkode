require 'bundler'
Bundler.require

$: << File.expand_path(File.join(['.']))
require 'server'

Faye::WebSocket.load_adapter('thin')

run App
