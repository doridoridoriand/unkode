require 'bundler'
Bundler.require

$: << File.expand_path(File.join(__FILE__, '..'))
$: << File.expand_path(File.join(__FILE__, '..', 'domain'))
$: << File.expand_path(File.join(__FILE__, '..', 'infrastructure'))
$: << File.expand_path(File.join(__FILE__, '..', 'helper'))
require 'validator'

# Infrastructure
require 'mysql_connector'
require 'redis_connector'

# Helper
require 'dwh_enum'

# Domain
require 'insert'

include Validator

@config = YAML.load_file(File.expand_path(File.join(__FILE__, '..', '..', 'config', 'config.yml')))
@config.mysql_directive_exists?
@config.redis_directive_exists?
