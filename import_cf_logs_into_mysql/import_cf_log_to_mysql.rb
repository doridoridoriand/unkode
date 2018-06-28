require 'optparse'
require 'mysql2'
require 'yaml'
require 'pry'

OPTIONS = {}
OptionParser.new do |opt|
  opt.on('-y yaml-file-path', 'Absolute directory path of configure file', String) {|v| OPTIONS[:yaml_file_path] = v}
end

config = YAML.load_file(File.expand_path(File.join(__FILE__, 'config', 'database.yml')))

binding/pry

client = Mysql::Client.new(:host => '',
                           :username => '',
                           :password => '',
                           :database => '')
