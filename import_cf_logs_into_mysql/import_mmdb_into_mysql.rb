require 'optparse'
require 'yaml'
require 'mysql2'
require 'maxminddb'
require 'ipaddress'
require 'parallel'
require 'thread'
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
#
# インサートの方針
# 使用するメモリ容量を削減するために、対象となるipアドレスを一気に生成してしまうのではなく、
# 順次範囲を決めて生成していき、privateIPでないこと、またMaxMindのDBにデータがあることを確認してからインサートする方式に変更する
###

OPTIONS = {}
TABLE_NAME = 'geoip_data'
OptionParser.new do |opt|
  opt.on('-y yaml-file-path', 'Absolute file path of configuration file',     String)  {|v| OPTIONS[:yaml_file_path]       = v}
  opt.on('-d mmdb_file_path', 'Absolute edirectory path of MaxMind DB file.', String)  {|v| OPTIONS[:mmdb_file_path]       = v}
  opt.on('-p number-of_process', 'Number of Processors.',                     Integer) {|v| OPTIONS[:number_of_processors] = v}
  opt.on('-c', 'Create DB Table')                                                      {|v| OPTIONS[:create_db_table]      = v}
  opt.on('-e', 'Execute insert from MaxMindDB to MySQL')                               {|v| OPTIONS[:execute]              = v}
  opt.parse!
end

raise OptionParser::MissingArgument, 'DirectoryPathNotDetectedError'     unless OPTIONS[:mmdb_file_path]
raise OptionParser::MissingArgument, 'ConfigureFilePathNotDetectedError' unless OPTIONS[:yaml_file_path]
raise OptionParser::MissingArgument, 'NumberOfProcessorNotSelectedError' unless OPTIONS[:number_of_processors]

mysql_config = YAML.load_file(OPTIONS[:yaml_file_path])['maxmind']

# データベースの存在チェック用に使うコネクション
mysql_client = Mysql2::Client.new(:host     => mysql_config['host'],
                                  :username => mysql_config['user'],
                                  :password => mysql_config['password'])
@mmdb_client  = MaxMindDB.new(OPTIONS[:mmdb_file_path])

# データベースがなかったら作る
mysql_client.query("create database `#{mysql_config['database']}`;") unless mysql_client.query('show databases;').map {|r| r.values}.flatten.include?(mysql_config['database'])

@mysql_client = Mysql2::Client.new(:host     => mysql_config['host'],
                                   :username => mysql_config['user'],
                                   :password => mysql_config['password'],
                                   :database => mysql_config['database'])
@logger = Logger.new STDOUT
@logger.level = Logger::INFO

public

def create_tables
  res = @mmdb_client.lookup('8.8.8.8')
  keys = ['continent', 'country', 'location', 'registered_country']
  keys.map {|table|
    unless @mysql_client.query('show tables').map {|r| r.values}.flatten.include?(table)
      table_keys = res[table].keys.map {|r| r if r != 'names'}.compact
      query = "create table `#{table}` ("
      query << "id bigint(20) unsigned not null auto_increment,"
      query << "ip varchar(191) not null,"
      table_keys.map {|key|
        query << "`#{key}` varchar(191),"
      }
      if res[table]['names']
        res[table]['names'].keys.map {|name|
          query << "`#{name}` varchar(191),"
        }
      end
      query << "primary key(`id`)) engine=InnoDB default charset=utf8;"
      @mysql_client.query(query)
    end
  }
end

def private_ip_address
  private_addr = []
  (IPAddress "10.0.0.0/8"    ).to('10.255.255.255').map  {|r| private_addr << r}
  (IPAddress "172.16.0.0/12" ).to('172.31.255.255').map  {|r| private_addr << r}
  (IPAddress "192.168.0.0/16").to('192.168.255.255').map {|r| private_addr << r}
  private_addr
end

# 並列処理可能なように、第一オクテットを引数として、x.0.0.0./8のレンジIPアドレスを配列として返すようにする
def ip_address(index)
  octet = (0..255).to_a
  addr = []
  octet.map {|i| octet.map {|j| octet.map {|k| addr << "#{index}.#{i}.#{j}.#{k}"}}}
  addr
end

def public_ipv4_addresses(index)
  # 以下IPアドレスを除外する
  # Class A 10.0.0.0～10.255.255.255     (10.0.0.0/8)
  # Class B 172.16.0.0～172.31.255.255   (172.16.0.0/12)
  # Class C 192.168.0.0～192.168.255.255 (192.168.0.0/16)
  ip_address(index) - private_ip_address
end

def insert_ipaddress(index)
  public_ipv4_addresses(index).map {|ip|
    if @@mmdb_client.loookup(ip).found?
    end
  }
end

create_tables if OPTIONS[:create_db_table]

if OPTIONS[:execute]
  Parallel.map((0..255).to_a, in_processes: OPTIONS[:number_of_processors]) {|index|
    insert_ipaddress(index)
  }
end
