$: << File.expand_path(File.join(__dir__, '..', 'lib'))
require 'bundler'
Bundler.require
require 'test_services_pb'

class TestServer < Helloworld::Greeter::Service

  def say_hello(hello_req, _unused_call)
    Helloworld::HelloReply.new(message: "Hello #{hello_req.name}")
  end
end
