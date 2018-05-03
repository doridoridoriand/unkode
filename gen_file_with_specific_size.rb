require 'uuid'
require 'optparse'
require 'securerandom'
require 'sys-filesystem'
require 'pry'

# ちゃんと独自例外内部で補足するようにしたい
class FilesizeExceedsTargetDriveError < StandardError
end

class FilesizeReachedError < StandardError
  raise StandardError
  exit 1
end

class FileAlreadyExistsError < StandardError
  raise StandardError
  exit 1
end

OPTIONS = {}
OptionParser.new do |opt|
  opt.on('-s size', 'File size(GB)',                             Integer) {|v| OPTIONS[:size]           = v}
  opt.on('-d directory-path', 'Output Directory with Full path', String)  {|v| OPTIONS[:directory_path] = v}
  opt.on('-f filename', '--filename',                            String)  {|v| OPTIONS[:filename]       = v}
  opt.parse!(ARGV)
end

raise OptionParser::MissingArgument, 'FileSizeNotSprcified'      unless OPTIONS[:size]
raise OptionParser::MissingArgument, 'DirectoryPathNotSpecified' unless OPTIONS[:directory_path]
raise OptionParser::MissingArgument, 'FileNameNotSpecified'      unless OPTIONS[:filename]

stat = Sys::Filesystem.stat(OPTIONS[:directory_path])
available_gigabytes = stat.blocks_free * stat.block_size / 1024 / 1024 / 1024

# 指定した保存ディレクトリのディスク容量が指定したファイルサイズ以下だった場合、例外
raise FilesizeExceedsTargetDriveError unless available_gigabytes > OPTIONS[:size]

absolute_file_path = "#{OPTIONS[:directory_path]}/#{OPTIONS[:filename]}.txt"

# 既にファイルが指定したディレクトリに存在する場合、例外とする
if Dir.exist?(absolute_file_path)
  raise FileAlreadyExistsError
end

while true
  begin
    File.open(absolute_file_path, 'a') do |r|
      r << SecureRandom.hex(256)
      if File.size(absolute_file_path) >= OPTIONS[:size] * 1024 * 1024 * 1024
        raise FilesizeReachedError
      end
    end
  rescue => e
  end
end

