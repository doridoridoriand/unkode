require 'systemu'
require 'ipaddress'
require 'yaml'

require 'pry'

ip_range_source = YAML.load_file(File.join(__dir__, '..', 'config', 'ip_range.yml'))

def normal(vendor_information)
  binding.pry
end

def wget(vendor_information)
end

def dig(vendor_information)
end

ip_range_source.first['address_range_list'].map {|vendor|
  binding.pry
  send(vendor.values.flatten.first['gettype'], vendor)
}

