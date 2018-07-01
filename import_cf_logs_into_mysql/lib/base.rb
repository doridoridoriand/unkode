require 'bundler'
Bundler.require

$: << File.expand_path(File.join(__FILE__, '..'))
$: << File.expand_path(File.join(__FILE__, 'domain'))
$: << File.expand_path(File.join(__FILE__, 'infrastructure'))
require 'validator'
require 'mysql_connector'
require 'redis_connector'

include Validator

config = YAML.load_file(File.expand_path(File.join(__FILE__, '..', '..', 'config', 'config.yml')))
config.mysql_directive_exists?
config.redis_directive_exists?
