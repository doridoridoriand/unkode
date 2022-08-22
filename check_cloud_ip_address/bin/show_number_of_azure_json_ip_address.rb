require 'parallel'
require 'json'
require 'ipaddress'
require 'open-uri'
require 'logger'
require 'pry'

logger = Logger.new STDOUT
logger.info('Start to parse IPv4 Address ranges of Azure.')

JSON_ENDPOINT = {public:  'https://download.microsoft.com/download/7/1/D/71D86715-5596-4529-9B13-DA13A5DE5B63/ServiceTags_Public_20220815.json',
                 gov:     'https://download.microsoft.com/download/6/4/D/64DB03BF-895B-4173-A8B1-BA4AD5D4DF22/ServiceTags_AzureGovernment_20220815.json',
                 germany: 'https://download.microsoft.com/download/0/7/6/076274AB-4B0B-4246-A422-4BAF1E03F974/ServiceTags_AzureGermany_20220307.json',
                 china:   'https://download.microsoft.com/download/9/D/0/9D03B7E2-4B80-4BF3-9B91-DA8C7D3EE9F9/ServiceTags_China_20220815.json'
}

cidrs = JSON_ENDPOINT.values.map {|r|
  JSON.parse(URI.open(r).read)['values'].map {|blc|
    blc['properties']['addressPrefixes']
  }
}.flatten

logger.info("Number of CIDR blocks: #{cidrs.count}")

ipv4_cidrs = cidrs.map {|cidr|
  if (IPAddress cidr).ipv4?
    cidr
  end
}.compact

ips = Parallel.map(ipv4_cidrs.map {|r| IPAddress r}) do |cidr|
  cidr.map {|ip| ip.octets.join('.')}
end
ips.flatten

logger.info("Completed to calculate number of IPv4 addresses. Number of IPv4 address of Azure: #{ips.flatten.count}")
