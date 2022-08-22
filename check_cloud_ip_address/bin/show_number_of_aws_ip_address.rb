require 'parallel'
require 'ipaddress'
require 'open-uri'
require 'json'
require 'logger'
require 'pry'

logger = Logger.new STDOUT
logger.info('Start to parse IP Address ranges of AWS.')

file = URI.open('https://ip-ranges.amazonaws.com/ip-ranges.json').read
res  = JSON.parse(file)['prefixes']
cidrs = res.map {|r| r['ip_prefix']}

logger.info("Number of IPv4 CIDR blocks: #{cidrs.count}")

ips = Parallel.map(cidrs.map {|r| IPAddress r}) do |cidr|
  cidr.map {|ip| ip.octets.join('.')}
end.flatten

logger.info("Completed to calculate number of IPv4 addresses. Number of IPv4 address of AWS: #{ips.flatten.count}")
