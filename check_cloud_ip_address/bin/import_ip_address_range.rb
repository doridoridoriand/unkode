require 'systemu'
require 'open-uri'
require 'json'
require 'rexml/document'
require 'ipaddress'
require 'parallel'
require 'redis'
require 'yaml'

require 'pry'

ip_range_source = YAML.load_file(File.join(__dir__, '..', 'config', 'ip_range.yml'))
db_config       = YAML.load_file(File.join(__dir__, '..', 'config', 'database.yml'))

public

def aws(vendor_information)
  file = open(vendor_information.values.flatten.first['uri']).read
  res = JSON.parse(file)['prefixes']
  cidrs = res.map {|r| r['ip_prefix']}
  cidrs.ip_lists
end

def azure(vendor_information)
  file = open(vendor_information.values.flatten.first['uri'].split('//').last).read
  xml_source = REXML::Document.new(file)
  res = xml_source.elements.each('/AzurePublicIpAddresses/Region/IpRange') do |elem|
    elem
  end
  cidrs = res.map {|r| r['Subnet']}
  cidrs.ip_lists
end

def gcp(vendor_information)
end

def ip_lists
  ips = Parallel.map(self.map {|r| IPAddress r}) do |cidr|
    cidr.map {|ip| ip.octets.join('.')}
  end
  ips.flatten
end

vendor_ips = ip_range_source.first['address_range_list'].map {|vendor|
  {vendor.keys.first.to_sym => send(vendor.keys.first, vendor)}
}

