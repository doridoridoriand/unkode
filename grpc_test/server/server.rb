$: << File.expand_path(File.join(__dir__))
require'bundler'
require 'server_base'
Bundler.require

server = GRPC::RpcServer.new
server.add_http2_port('localhost:50051', :this_port_is_insecure)
server.handle(TestServer)

server.run_till_terminated
