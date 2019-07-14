require 'bundler'
Bundler.require

EM.run {
  client = Faye::WebSocket::Client.new('ws://localhost:8000/')
  client.on :open do |event|
    p :open
    client.send('testtext')
  end

  client.on :message do |event|
    p :message
    binding.pry
    p event.data
  end

  client.on :close do |event|
    p :close
  end
}
