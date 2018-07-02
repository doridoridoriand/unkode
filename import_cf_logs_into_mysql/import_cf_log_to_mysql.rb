require 'optparse'
require 'mysql2'
require 'yaml'
require 'zlib'
require 'pry'

OPTIONS = {}
OptionParser.new do |opt|
  opt.on('-y yaml-file-path', 'Absolute directory path of configure file', String) {|v| OPTIONS[:yaml_file_path]   = v}
  opt.on('-d directory-path', 'Absolute directory path of log files',      String) {|v| OPTIONS[:directory_path]   = v}
  opt.on('-c',  '--create-db-schema')                                              {|v| OPTIONS[:create_db_schema] = v}
  opt.parse!
end

raise OptionParser::MissingArgument, 'DirectoryPathNotDetectedError'     unless OPTIONS[:directory_path]
raise OptionParser::MissingArgument, 'ConfigureFilePathNotDetectedError' unless OPTIONS[:yaml_file_path]

mysql_config = YAML.load_file(OPTIONS[:yaml_file_path])['mysql']

@log_file_pathes = Dir.glob("#{OPTIONS[:directory_path]}/*")

@client = Mysql2::Client.new(:host =>     mysql_config['host'],
                           :username => mysql_config['username'],
                           :password => mysql_config['password'],
                           :database => mysql_config['database'])

public

def create_schema
  rows   = @log_file_pathes.sample(1).first.log_contents
  fields = rows.to_arrays[1].first.split(' ')
  fields.shift
  fields
end

def insert_row

end

def log_contents
  Zlib::GzipReader.open(self) {|l| l.read}
end

def to_arrays
  self.split(/\n/).map {|r| r.split(/\t/)}
end

create_schema if OPTIONS[:create_db_schema]
