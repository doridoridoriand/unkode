require 'net/http'
require 'json'
require 'optparse'

OPTIONS = {}
OptionParser.new do |opt|
  opt.on('-b bot_url',     'Slack Bot URL',                     String) {|v| OPTIONS[:bot_url]     = v}
  opt.on('-d description', 'Description what you want to post', String) {|v| OPTIONS[:description] = v}
  opt.parse!(ARGV)
end

uri = URI.parse(OPTIONS[:bot_url])
https = Net::HTTP.new(uri.host, uri.port)
https.use_ssl = true
req = Net::HTTP::Post.new(uri.request_uri)
req['Content-Type'] = 'application/json'
req.body = {"text" => OPTIONS[:description]}.to_json
https.request(req)
