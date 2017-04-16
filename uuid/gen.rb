require 'securerandom'
require 'mysql2'

client = Mysql2::Client.new(:host => 'uuid.c9pxhxbdcuca.ap-northeast-1.rds.amazonaws.com',
                            :username => 'dorian',
                            :password => 'password',
                            :database => 'uuid'
)

while true do
  begin
    client.query("insert into uuid.ruby (`uuid`) values ('#{SecureRandom.uuid}')")
    sleep(1)
  rescue => e
    p e
  end
end
