require 'optparse'
require 'net/http'

OPTIONS = {}
OptionParser.new do |opt|
  opt.on('-u URL', '--url=URL', String, 'URL to check status') { |v| OPTIONS[:url] = v }
  opt.parse(ARGV)
end

raise OptionParser::MissingArgument, 'NoURLFoundError' unless OPTIONS[:url]

begin
  uri = URI.parse(OPTIONS[:url])
  response = Net::HTTP.get_response(uri)
  puts "Status for #{uri}: #{response.code} #{response.message}"
rescue URI::InvalidURIError
  abort "Error: Invalid URL format"
rescue SocketError
  abort "Error: Could not connect to the server"
rescue => e
  abort "Error: #{e.message}"
end
