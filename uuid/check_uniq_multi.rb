require 'mysql2'
require 'net/http'
require 'uri'
require 'json'
require 'parallel'

#t_start = Time.now
#numbers = (0..1000000).to_a
#rand = Random.new()
#Parallel.each(numbers, in_thread: 8) do |num|
#  num + rand.rand(200)
#end
#t_end = Time.now
#
#p t_end - t_start
client = Mysql2::Client.new(:host => '',
                            :username => 'root',
                            :password => 'password',
                            :database => 'uuid'
)

number_of_data = client.query("select id from uuid.ruby order by id desc limit 1").map {|data| data["id"]}.first

index_arr = (1..number_of_data).to_a
collision_uuid = []

Parallel.each(index_arr, in_thread: 8) do |id|
  uuid = client.query("select uuid from uuid.ruby where id = #{id}").map {|res| res['uuid']}.first
  count = client.query("select * from uuid.ruby where uuid = #{"'" + uuid + "'"}").map {|res| res['id']}.to_a.count

  if count.to_i === 1
    p "#{uuid}: is unique"
  else
    collision_uuid << uuid
  end
end

if collision_uuid.count != 0
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
