$: << File.expand_path(File.join(__dir__))
require'bundler'
require 'yaml'
require 'server_base'
Bundler.require

config = YAML.load_file(File.join(__dir__, '..', 'config', 'server.yml'))['server']

server = GRPC::RpcServer.new
server.add_http2_port("#{config['host']}:#{config['port']}", :this_port_is_insecure)
server.handle(TestServer)
server.run_till_terminated
