require 'optparse'
require 'yaml'
require 'mysql2'
require 'maxminddb'
require 'logger'
require 'pry'

###
# maxMindのGeoLite2データベースをMySQLに投入するスクリプト
# 0.0.0.0 ~ 255.255.255.255を機械的に投入しちゃう感じ
# 約43奥レコード生成されるのでDBが試される
# 実際には、現時点でMaxMind側の方に存在しないレコードはスキップさせるので、実際にはかなり少なくなるはず
# ライブラリこれ使う
# https://github.com/yhirose/maxminddb
# gz形式は予め解凍しておくこと
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
@mysql_client = Mysql2::Client.new(:host     => mysql_config['host'],
                                   :username => mysql_config['user'],
                                   :password => mysql_config['password'],
                                   :database => mysql_config['database'])
@mmdb_client  = MaxMindDB.new(OPTIONS[:mmdb_file_path])

@logger = Logger.new STDOUT
@logger.level = Logger::INFO

public

def create_table
  binding.pry
end

def import_geolocation
end

tables = @mysql_client.query("show tables").map {|r| r}
binding.pry
create_table if OPTIONS[:create_db_table] 
