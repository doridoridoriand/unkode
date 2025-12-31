require 'optparse'
require 'securerandom'
require 'sys-filesystem'
require 'pry'

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
available_gigabytes = stat.bytes_free / 1024 / 1024 / 1024

# 指定した保存ディレクトリのディスク容量が指定したファイルサイズ以下だった場合、例外
raise StandardError, 'FilesizeExceedsTargetDriveError' unless available_gigabytes > OPTIONS[:size]

absolute_file_path = "#{OPTIONS[:directory_path]}/#{OPTIONS[:filename]}.txt"

# 既にファイルが指定したディレクトリに存在する場合、例外とする
raise StandardError, 'FileAlreadyExistsError' if File.file?(absolute_file_path)

target_size_bytes = OPTIONS[:size] * 1024 * 1024 * 1024
chunk_size = 10 * 1024 * 1024  # Write 10MB chunks at a time for better performance

File.open(absolute_file_path, 'w') do |f|
  bytes_written = 0
  
  while bytes_written < target_size_bytes
    remaining_bytes = target_size_bytes - bytes_written
    
    # Adjust chunk size for the last write to avoid overshooting
    write_size = [chunk_size, remaining_bytes].min
    
    # Generate hex data efficiently
    # SecureRandom.hex(n) generates n random bytes and returns 2*n hex characters
    # So for write_size bytes, we need write_size/2 as the parameter
    hex_data = SecureRandom.hex(write_size / 2)
    
    # Truncate to exact size needed
    hex_data = hex_data[0, write_size] if hex_data.length > write_size
    
    f.write(hex_data)
    bytes_written += hex_data.length
  end
end

exit

