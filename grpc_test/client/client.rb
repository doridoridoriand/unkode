$: << File.expand_path(File.join(__dir__, '..', 'lib'))
require 'bundler'
require 'test_services_pb'
require 'optparse'
Bundler.require

OPTIONS = {}
OptionParser.new do |opt|
  opt.on('-u user', 'The user what you want to send.', String) {|v| OPTIONS[:user] = v}
  opt.parse!(ARGV)
end

raise OptionParser::MissingArgument, 'UserNotDetectedError' unless OPTIONS[:user]

stub = Helloworld::Greeter::Stub.new('localhost:50051', :this_channel_is_insecure)
message = stub.say_hello(Helloworld::HelloRequest.new(name: OPTIONS[:user])).message
puts message


