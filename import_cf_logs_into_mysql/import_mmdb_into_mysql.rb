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
#
# 実行例
# ruby import_mmdb_into_mysql.rb -y config/config.yml -d /mnt/datastorage/GeoLite2-City.mmdb -p 24 -e
###

OPTIONS = {}
TABLE_NAME = 'geoip_data'
OptionParser.new do |opt|
  opt.on('-y', '--yaml-file-path VALUE',    String,  'Absolute file path of configuration file')     {|v| OPTIONS[:yaml_file_path]       = v}
  opt.on('-d', '--mmdb_file_path VALUE',    String,  'Absolute edirectory path of MaxMind DB file.') {|v| OPTIONS[:mmdb_file_path]       = v}
  opt.on('-p', '--number-of_process VALUE', Integer, 'Number of Processors.')                        {|v| OPTIONS[:number_of_processors] = v}
  opt.on('-c', '--create-db-table',                  'Create DB Table')                              {|v| OPTIONS[:create_db_table]      = v}
  opt.on('-e', '--execute',                          'Execute insert from MaxMindDB to MySQL')       {|v| OPTIONS[:execute]              = v}
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

@@mysql_client = Mysql2::Client.new(:host     => mysql_config['host'],
                                   :username => mysql_config['user'],
                                   :password => mysql_config['password'],
                                   :database => mysql_config['database'])
@@logger = Logger.new "#{__dir__}/execute_#{__FILE__}_#{Time.now.to_s.gsub(' ', '')}.log"
@@logger.level = Logger::INFO

public

def create_tables
  res = @mmdb_client.lookup('8.8.8.8')
  keys = ['continent', 'country', 'location', 'registered_country']
  keys.map {|table|
    unless @@mysql_client.query('show tables').map {|r| r.values}.flatten.include?(table)
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
      @@mysql_client.query(query)
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
  # ip_address(index) - private_ip_address
  # MaxMindのDBに存在するもののみimportすることにした。この処理いらない気がするので一旦コメントアウト。
  # 実際のデータを見てから必要可否判断する。
  ip_address(index)
end

def execute(query)
  @@mysql_client.query(query)
end

def import(ip)
  keys = ['continent', 'country', 'location', 'registered_country']
  keys.map {|k|
    if self[k]
      begin
        items = []
        items << ip
        self[k].values.map {|r|
          if r.class.to_s != 'Hash'
            items << r
          end
          if r.class.to_s === 'Hash'
            items << r.values
          end
        }
        items = items.flatten
        result = execute("desc maxmind.#{k}").map {|r| r}
        result.shift
        column = result.map {|r| "`#{r['Field']}`"}.join(',')
        query = "insert into maxmind.#{k}(#{column}) values(#{items.map {|r| "'#{r}'"}.join(',')})"
        execue(query)
      rescue => e
        @@logger.warn("Something wrong with #{query}. Error message: #{e.message}")
      end
    end
  }
end

# DBに書くんじゃなくて単純に作成したSQLをファイルに書き出してみる
def export_to_file(query)
  open('./output_mmdb.sql', 'a') do |fs|
    fs << query
  end
end

def insert_ipaddress(index)
  @@logger.info("Start to create IP addresses. First octet is #{index}")
  public_ipv4_addresses(index).map {|ip|
    if @mmdb_client.lookup(ip).found?
      content = @mmdb_client.lookup(ip)
      content.import(ip)
    end
  }
end

create_tables if OPTIONS[:create_db_table]

if OPTIONS[:execute]
  Parallel.map((0..255).to_a, in_processes: OPTIONS[:number_of_processors]) {|index|
    insert_ipaddress(index)
  }
end
