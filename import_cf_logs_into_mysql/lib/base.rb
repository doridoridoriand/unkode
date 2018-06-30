require 'bundler'
Bundler.require

$: << File.expand_path(File.join(__FILE__, '..'))
require 'validator'

config = YAML.load_file(File.expand_path(File.join(__FILE__, '..', '..', 'config', 'config.yml')))

