require 'net/ssh'
require 'securerandom'
require 'pry'
require 'logger'

host = 'serer'
user = 'user'

logger = Logger.new('res.log')

Net::SSH.start(host, user) do |session|
  base_directory = '~/inode'
  session.exec!("mkdir #{base_directory}") if session.exec!("ls #{base_directory}").include?('No such file or directory')
  10.times {|i|
    sub_directory = "#{base_directory}/#{i}"
    session.exec!("mkdir #{sub_directory}") if session.exec!("ls #{sub_directory}").include?('No such file or directory')
    1000000.times {|j|
      uuid = SecureRandom.uuid
      filename_with_path = "#{base_directory}/#{i}/#{uuid}"
      session.exec!("touch #{filename_with_path}")
      if j % 10 == 0
        res = session.exec!("df -i")
        inodes = res.split(/\n/).map {|line| line if line.include?('dev')}.compact![1].split(' ')
        current_inodes = {inodes: inodes[1], iused: inodes[2], ifree: inodes[3], percent: inodes[4]}
        logger.info("Used: #{current_inodes[:iused]}  Remain: #{current_inodes[:ifree]}  Percentage: #{(current_inodes[:ifree].to_f / current_inodes[:inodes].to_f * 100).to_s[0..5]}%")
      end
    }
  }
end
