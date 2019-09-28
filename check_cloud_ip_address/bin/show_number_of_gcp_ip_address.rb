require 'parallel'
require 'systemu'
require 'ipaddress'
require 'open-uri'
require 'logger'
require 'pry'

logger = Logger.new STDOUT
logger.info('Start to parse IP Address ranges of GCP.')

pid, res = systemu "dig -t txt _spf.google.com +short"
netblocks_txt = res.split(' ').map {|r|
  r if r.include?('include')
}.compact.map {|r|
  r.split(':').last
}
cidrs = netblocks_txt.map {|r|
  pid, res = systemu "dig -t txt #{r} +short"
  res.split(' ').map {|r|
    r if r.include?('ip4')
  }.compact
}.flatten.map {|r| r.split(':').last}

logger.info("Number of CIDR blocks: #{cidrs.count}")

ips = Parallel.map(cidrs.map {|r| IPAddress r}) do |cidr|
  cidr.map {|ip| ip.octets.join('.')}
end.flatten

logger.info("Completed to calculate number of IP addresses. Number of IP address of GCP: #{ips.flatten.count}")
