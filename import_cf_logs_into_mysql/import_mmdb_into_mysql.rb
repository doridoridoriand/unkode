require 'optparse'
require 'yaml'
require 'mysql2'
require 'maxminddb'
require 'ipaddress'
require 'parallel'
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
  opt.on('-y yaml-file-path', 'Absolute file path of configuration file',     String) {|v| OPTIONS[:yaml_file_path]  = v}
  opt.on('-d mmdb_file_path', 'Absolute edirectory path of MaxMind DB file.', String) {|v| OPTIONS[:mmdb_file_path]  = v}
  opt.on('-c', 'Create DB Table')                                                      {|v| OPTIONS[:create_db_table] = v}
  opt.parse!
end

raise OptionParser::MissingArgument, 'DirectoryPathNotDetectedError'     unless OPTIONS[:mmdb_file_path]
raise OptionParser::MissingArgument, 'ConfigureFilePathNotDetectedError' unless OPTIONS[:yaml_file_path]

mysql_config = YAML.load_file(OPTIONS[:yaml_file_path])['maxmind']
@mysql_client = Mysql2::Client.new(:host     => mysql_config['host'],
                                   :username => mysql_config['user'],
                                   :password => mysql_config['password'])
@mmdb_client  = MaxMindDB.new(OPTIONS[:mmdb_file_path])

# データベースがなかったら作る
@mysql_client.query("create database `#{mysql_config['database']}`;") if !@mysql_client.query('show databases;').map {|r| r.values}.flatten.include?(mysql_config['database'])

@logger = Logger.new STDOUT
@logger.level = Logger::INFO

public

def create_table
  res = @mmdb_client.lookup('8.8.8.8')
  keys = ['continent', 'country', 'location', 'registered_country']
  keys.map {|table|
    table_keys = res[table].keys.map {|r| r if r != 'names'}.compact
    query = "create table `#{table}` ("
    query << "id bigint(20) unsigned not null auto_increment,"
    table_keys.map {|key|
      query << "`#{key}` varchar(191),"
    }
    p res[table]['names']
    res[table]['names'].keys.map {|name|
      query << "`#{name}` varchar(191),"
    }
    query << "primary key(`id`)) engine=InnoDB default charset=utf8;"
    @mysql_client.query(query)
  }
end

def private_ip_address
  private_addr = []
  (IPAddress "10.0.0.0/8"    ).to('10.255.255.255').map  {|r| private_addr << r}
  (IPAddress "172.16.0.0/12" ).to('172.31.255.255').map  {|r| private_addr << r}
  (IPAddress "192.168.0.0/16").to('192.168.255.255').map {|r| private_addr << r}
  private_addr
end

def all_ip_address
  octet = (0..25).to_a
  Parallel.map(octet) {|index|
    __ip_address(index)
  }
end

# 並列処理可能なように、第一オクテットを引数として、x.0.0.0./8のレンジIPアドレスを配列として返すようにする
def __ip_address(index)
  octet = (0..255).to_a
  addr = []
  octet.map {|i| octet.map {|j| octet.map {|k| addr << "#{index}.#{i}.#{j}.#{k}"}}}
  addr
end

def public_ipv4_addresses
  # 以下IPアドレスを除外する
  # Class A 10.0.0.0～10.255.255.255     (10.0.0.0/8)
  # Class B 172.16.0.0～172.31.255.255   (172.16.0.0/12)
  # Class C 192.168.0.0～192.168.255.255 (192.168.0.0/16)
  all_ip_address - private_ip_address
end

def import_geolocation
end

databases = @mysql_client.query("show databases").map {|r| r}
create_table if OPTIONS[:create_db_table] && !databases.map {|l| l.values}.flatten.include?('maxmind')

