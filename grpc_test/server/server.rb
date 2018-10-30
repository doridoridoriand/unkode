$: << File.expand_path(File.join(__dir__, '..', 'lib'))
require 'bundler'
Bundler.require
require 'test_services_pb.rb'

class TestService < Helloworld::Greeter::Service

end
