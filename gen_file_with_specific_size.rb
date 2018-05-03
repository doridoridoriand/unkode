require 'uuid'
require 'optparse'
require 'securerandom'
require 'sys-filesystem'
require 'pry'

OPTIONS = {}
OptionParser.new do |opt|
  opt.on('-s size', '--size',                                      Integer) {|v| OPTIONS[:size]           = v}
  opt.on('-o output-directory', 'Output Directory with Full path', String)  {|v| OPTIONS[:directory_path] = v}
  opt.on('-n filename', '--filename',                              String)  {|v| OPTIONS[:filename]       = v}
  opt.parse!(ARGV)
end

# ファイルサイズはGB指定
raise OptionParser::MissingArgument, 'FileSizeNotSprcified'      unless OPTIONS[:size]
raise OptionParser::MissingArgument, 'DirectoryPathNotSpecified' unless OPTIONS[:directory_path]
raise OptionParser::MissingArgument, 'FileNameNotSpecified'      unless OPTIONS[:filename]

stat = Sys::Filesystem.stat(OPTIONS[:directory_path])
p stat.blocks_free * stat.block_size

binding.pry
