require 'parallel'
require 'ipaddress'
require 'open-uri'
require 'json'
require 'logger'
require 'pry'

logger = Logger.new STDOUT
logger.info('Start to parse IP Address ranges of M247.')

# ASN: AS9009
CIDRS = [
  "89.238.128.0/18",
  "93.110.32.0/20",
  "217.64.112.0/20",
  "217.151.96.0/20",
  "89.22.224.0/20",
  "158.46.144.0/20",
  "78.136.232.0/21",
  "78.136.224.0/21",
  "88.204.40.0/21",
  "84.39.112.0/21",
  "158.46.136.0/21",
  "92.51.48.0/21",
  "91.102.64.0/21",
  "158.46.176.0/22",
  "185.220.216.0/22",
  "185.198.84.0/22",
  "89.249.76.0/22",
  "185.9.16.0/22",
  "185.221.196.0/22",
  "168.80.60.0/22"
]

logger.info("Number of CIDR blocks: #{CIDRS.count}")

ips = Parallel.map(CIDRS.map {|r| IPAddress r}) do |cidr|
  cidr.map {|ip| ip.octets.join('.')}
end.flatten

logger.info("Completed to calculate number of IP addresses. Number of IP address of M247: #{ips.flatten.count}")
