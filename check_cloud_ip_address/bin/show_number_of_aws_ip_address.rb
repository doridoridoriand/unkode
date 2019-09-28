require 'parallel'
require 'ipaddress'
require 'open-uri'
require 'logger'
require 'pry'

public

logger = Logger.new STDOUT
logger.info('Start to parse IP Address ranges of AWS.')

file = open('https://ip-ranges.amazonaws.com/ip-ranges.json').read
res  = JSON.parse(file)['prefixes']
cidrs = res.map {|r| r['ip_prefix']}

logger.info("Number of CIDR blocks: #{cidrs.count}")

ips = Parallel.map(cidrs.map {|r| IPAddress r}) do |cidr|
  cidr.map {|ip| ip.octets.join('.')}
end
ips.flatten

logger.info("Completed to calculate number of IP addresses. Number of IP address of AWS: #{ips.flatten.count}")