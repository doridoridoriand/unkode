require 'bundler'
Bundler.require

$: << File.expand_path(File.join(__FILE__, '..'))
require 'validator'

include Validator

config = YAML.load_file(File.expand_path(File.join(__FILE__, '..', '..', 'config', 'config.yml')))
config.mysql_directive_exists?
