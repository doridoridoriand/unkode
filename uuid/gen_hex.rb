require 'securerandom'
require 'mysql2'

client = Mysql2::Client.new(:host => 'uuid.c9pxhxbdcuca.ap-northeast-1.rds.amazonaws.com',
                            :username => 'dorian',
                            :password => 'password',
                            :database => 'uuid'
)

while true do
  begin
    uuid = SecureRandom.hex(31)
    client.query("insert into uuid.ruby_hex (`uuid`) values ('#{uuid}')")
    puts uuid
  rescue => e
    p e
  end
end
