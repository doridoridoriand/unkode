require 'parallel'
require 'rexml/document'
require 'ipaddress'
require 'open-uri'
require 'logger'
require 'pry'

logger = Logger.new STDOUT
logger.info('Start to parse IP Address ranges of Azure.')

file = open('https://download.microsoft.com/download/0/1/8/018E208D-54F8-44CD-AA26-CD7BC9524A8C/PublicIPs_20190923.xml').read
xml_source = REXML::Document.new(file)
cidrs = xml_source.elements.each('/AzurePublicIpAddresses/Region/IpRange') do |elem|
  elem['Subnet']
end.map {|r| r['Subnet']}

logger.info("Number of CIDR blocks: #{cidrs.count}")

ips = Parallel.map(cidrs.map {|r| IPAddress r}) do |cidr|
  cidr.map {|ip| ip.octets.join('.')}
end
ips.flatten

logger.info("Completed to calculate number of IP addresses. Number of IP address of Azure: #{ips.flatten.count}")
