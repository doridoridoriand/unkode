require 'optparse'
require 'yaml'
require 'maxminddb'
require 'logger'
require 'pry'

###
# maxMindのGeoLite2データベースをMySQLに投入するスクリプト
# ライブラリこれ使う
# https://github.com/yhirose/maxminddb
###

OPTIONS = {}
TABLE_NAME = 'geoip_data'
OptionParser.new do |opt|
  opt.on('-y yaml-file-path',      'Absolute file path of configuration file',     String) {|v| OPTIONS[:yaml_file_path]  = v}
  opt.on('-d mmdb_directory_path', 'Absolute edirectory path of MaxMind DB file.', String) {|v| OPTIONS[:mmdb_file_path]  = v}
  opt.on('-c' 'Create DB Table')                                                           {|v| OPTIONS[:create_db_table] = v}
  opt.parse!
end

raise OptionParser::MissingArgument, 'DirectoryPathNotDetectedError'     unless OPTIONS[:mmdb_file_path]
raise OptionParser::MissingArgument, 'ConfigureFilePathNotDetectedError' unless OPTIONS[:yaml_file_path]

mysql_config = YAML.load_file(OPTIONS[:yaml_file_path])['mysql']

@logger = Logger.new STDOUT
@logger.level = Logger::INFO

public

def create_table
end

def import_geolocation
end
binding.pry
