require 'optparse'
require 'net/http'
require 'pry'

OPTIONS = {}
OptionParser.new do |opt|
  opt.on('-u url', '--url', String) {|v| OPTIONS[:url] = v}
  opt.parse(ARGV)
end

raise OptionParser::MissingArgument, 'NoURLFoundError' unless OPTIONS[:url]

res = URI.parse(OPTIONS[:url])
_  = res
binding.pry
