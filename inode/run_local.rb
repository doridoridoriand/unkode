require 'fileutils'
require 'securerandom'
require 'pry'
require 'systemu'
require 'logger'

logger = Logger.new('res.local.log')

base_directory = './inode'
FileUtils.mkdir_p(base_directory) if !Dir.exist?(base_directory)

10.times {|i|
  sub_directory = "#{base_directory}/#{i}"
  FileUtils.mkdir_p(sub_directory) if !Dir.exist?(sub_directory)
  1000000.times {|j|
    uuid = SecureRandom.uuid
    filename_with_path = "#{sub_directory}/#{uuid}"
    FileUtils.touch(filename_with_path)
    if j % 10 == 0
      status, out, err = systemu 'df -i'
      inodes = out.split(/\n/).map {|line| line if line.include?('dev')}.compact![1].split(' ')
      current_inodes = {inodes: inodes[1], iused: inodes[2], ifree: inodes[3], percent: inodes[4]}
      logger.info("Used: #{current_inodes[:iused]}  Remain: #{current_inodes[:ifree]}  Percentage: #{(current_inodes[:ifree].to_f / current_inodes[:inodes].to_f * 100).to_s[0..5]}")
    end
  }
}

