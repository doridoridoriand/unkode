require 'mechanize'
require 'csv'
require 'json'
require 'pry'

alphabet = ('A'..'Z').to_a
base_url = 'https://en.wikipedia.org/wiki/List_of_airports_by_IATA_code:_'

public

def url_to_document
  agent                  = Mechanize.new
  agent.log              = Logger.new STDOUT
  agent.user_agent_alias = 'Mac Safari'
  Nokogiri::HTML.parse(agent.get(self).content)
end

def row_to_hash
  keys = ['IATA', 'ICAO', 'AIRPORT_NAME', 'LOCATION_SERVED', 'TIME', 'DST']
  {keys[0].to_sym => self[1],
   keys[1].to_sym => self[3],
   keys[2].to_sym => self[5],
   keys[3].to_sym => self[7],
   keys[4].to_sym => self[9],
   keys[5].to_sym => self[11]
  }
end

contents = alphabet.map {|a|
  sleep 1
  documents      = (base_url + a).url_to_document
  table_elements = documents.xpath("//table/tbody/tr")
  contents       = table_elements.map {|r| r.children.map {|e| e.text}}.map {|r| r.map {|f| f.gsub("\n", '')}}

  contents.map {|e| e.row_to_hash if e[7]}.compact
}
resize = []
contents.map {|r| r.map {|f| resize << f}}
File.open('airports.json', 'w') do |fs|
  fs << resize.to_json
end
