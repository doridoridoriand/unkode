require 'systemu'
require 'open-uri'
require 'json'
require 'ipaddress'
require 'parallel'
require 'yaml'

require 'pry'

ip_range_source = YAML.load_file(File.join(__dir__, '..', 'config', 'ip_range.yml'))

def aws(vendor_information)
  file = open(vendor_information.values.flatten.first['uri']).read
  cidrs = JSON.parse(file)['prefixes']
  ips = Parallel.map(cidrs.map {|r| IPAddress r['ip_prefix']}) do |cidr|
    cidr.map {|ip| ip.octets.join('.')}
  end
  ips.flatten
end

def azure(vendor_information)
end

def gcp(vendor_information)
end

ip_range_source.first['address_range_list'].map {|vendor|
  send(vendor.keys.first, vendor)
}

