require 'uuid'
require 'securerandom'
require 'pry'

OPTIONS = {}
OptionParser.new do |opt|
  opt.on('-s size', '--size', Integer) {|v| OPTIONS[:size] = v}
  opt.on('-n filename', '--filename', String) {|v| OPTIONS[:filename] = v}
  opt.parse!(ARGV)
end

# ファイルサイズはGB指定
raise OptionParser::MissingArgument, 'FileSizeNotSprcified' unless OPTIONS[:size]
raise OptionParser::MissingArgument, 'FileNameNotSpecified' unless OPTIONS[:filename]

