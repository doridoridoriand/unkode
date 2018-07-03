require 'optparse'
require 'mysql2'
require 'yaml'
require 'zlib'
require 'logger'
require 'pry'

OPTIONS = {}
TABLE_NAME = 'cflog'
OptionParser.new do |opt|
  opt.on('-y yaml-file-path', 'Absolute directory path of configure file', String) {|v| OPTIONS[:yaml_file_path]   = v}
  opt.on('-d directory-path', 'Absolute directory path of log files',      String) {|v| OPTIONS[:directory_path]   = v}
  opt.on('-c',  '--create-db-schema')                                              {|v| OPTIONS[:create_db_schema] = v}
  opt.on('-i',  '--insert')                                                        {|v| OPTIONS[:insert]           = v}
  opt.parse!
end

raise OptionParser::MissingArgument, 'DirectoryPathNotDetectedError'     unless OPTIONS[:directory_path]
raise OptionParser::MissingArgument, 'ConfigureFilePathNotDetectedError' unless OPTIONS[:yaml_file_path]

mysql_config = YAML.load_file(OPTIONS[:yaml_file_path])['mysql']

@log_file_pathes = Dir.glob("#{OPTIONS[:directory_path]}/*")

@logger = Logger.new STDOUT
@logger.level = Logger::INFO

@client = Mysql2::Client.new(:host =>     mysql_config['host'],
                             :username => mysql_config['username'],
                             :password => mysql_config['password'],
                             :database => mysql_config['database'])

public

def create_schema
  begin
    rows   = @log_file_pathes.sample(1).first.log_contents
    fields = rows.to_arrays[1].first.split(' ')
    fields.shift
    query = "create table `#{TABLE_NAME}` ("
    query << "id bigint(20) unsigned not null auto_increment,"
    fields.map {|r|
      query << "`#{r}` text not null,"
    }
    query << "primary key(`id`)) engine=InnoDB default charset=utf8;"
    @client.query(query)
    res = @client.query('show tables').map {|r| r}
    if res.first.values.first === TABLE_NAME
      true
    end
  rescue => e
    raise e.exception("An error occurs during create_table. Error message: #{e.message}")
  end
end

def insert_row
  rows   = @log_file_pathes.sample(1).first.log_contents
  column = rows.to_arrays[1].first.split(' ')
  column.shift
  column = column.map {|r| "`#{r}`"}.join(',')

  rows   = @log_file_pathes.sample(300).map {|r| r.log_contents}
  @logger.info("Log files load completed.")
  fields = rows.map {|r| r.to_arrays}.map {|r| r.map {|f| f if f.count > 1}.compact}
  fields.map {|file| file.map {|r|
    q = "insert into #{TABLE_NAME}(#{column}) values(#{r.map {|f| "'#{f}'"}.join(',')})"
    @client.query(q)
  }}
end

def log_contents
  Zlib::GzipReader.open(self) {|l| l.read}
end

def to_arrays
  self.split(/\n/).map {|r| r.split(/\t/)}
end

#テーブルの存在を確認する。なければcreate_schemaを実行
tables = @client.query("show tables").map {|r| r}
create_schema if OPTIONS[:create_db_schema] && tables.size == 0

tables = @client.query("show tables").map {|r| r}
insert_row if OPTIONS[:insert] && tables.size != 0
