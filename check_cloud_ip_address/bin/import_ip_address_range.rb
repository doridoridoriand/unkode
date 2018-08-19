require 'systemu'
require 'ipaddress'
require 'yaml'

require 'pry'

ip_range_source = YAML.load_file(File.join(__dir__, '..', 'config', 'ip_range.yml'))

binding.pry
