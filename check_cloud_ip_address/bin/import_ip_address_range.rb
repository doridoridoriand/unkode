require 'systemu'
require 'open-uri'
require 'json'
require 'ipaddress'
require 'yaml'

require 'pry'

ip_range_source = YAML.load_file(File.join(__dir__, '..', 'config', 'ip_range.yml'))

def normal(vendor_information)
  file = open(vendor_information.values.flatten.first['uri']).read
  json_data = JSON.parse(file)
  json_data['prefixes'].map {|r| IPAddress r['ip_prefix']}
  binding.pry
end

def wget(vendor_information)
end

def dig(vendor_information)
end

ip_range_source.first['address_range_list'].map {|vendor|
  send(vendor.values.flatten.first['gettype'], vendor)
}

