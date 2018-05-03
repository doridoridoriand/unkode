require 'uuid'
require 'optparse'
require 'securerandom'
require 'sys-filesystem'
require 'pry'

# ちゃんと独自例外内部で補足するようにしたい
class FilesizeExceedsTargetDriveError < StandardError
end

OPTIONS = {}
OptionParser.new do |opt|
  opt.on('-s size', 'File size(GB)',                               Integer) {|v| OPTIONS[:size]           = v}
  opt.on('-o output-directory', 'Output Directory with Full path', String)  {|v| OPTIONS[:directory_path] = v}
  opt.on('-n filename', '--filename',                              String)  {|v| OPTIONS[:filename]       = v}
  opt.parse!(ARGV)
end

raise OptionParser::MissingArgument, 'FileSizeNotSprcified'      unless OPTIONS[:size]
raise OptionParser::MissingArgument, 'DirectoryPathNotSpecified' unless OPTIONS[:directory_path]
raise OptionParser::MissingArgument, 'FileNameNotSpecified'      unless OPTIONS[:filename]

stat = Sys::Filesystem.stat(OPTIONS[:directory_path])
available_gigabytes = stat.blocks_free * stat.block_size / 1024 / 1024 / 1024

raise FilesizeExceedsTargetDriveError unless available_gigabytes > OPTIONS[:size]

#binding.pry
