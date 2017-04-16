require 'mysql2'
require 'net/http'
require 'uri'
require 'json'

client = Mysql2::Client.new(:host => 'uuid.c9pxhxbdcuca.ap-northeast-1.rds.amazonaws.com',
                            :username => 'dorian',
                            :password => 'password',
                            :database => 'uuid'
)

data = client.query("select uuid from uuid.ruby").map {|row| row['uuid']}.to_a

p data.length
p data.uniq.length
if data.length != data.uniq.length
  text = 'UUID collision occuerd!!!!'
else
  text = "生成されたUUID: #{data.length.to_s}\n今日もUUIDは平和です"
end
puts text
uri = URI.parse('')
https = Net::HTTP.new(uri.host, uri.port)
https.use_ssl = true
req = Net::HTTP::Post.new(uri.request_uri)
req['Content-Type'] = 'application/json'
req.body = {"text" => text}.to_json
https.request(req)
