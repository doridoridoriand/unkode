require 'mechanize'
require 'csv'
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

#CSV.open('airports.csv', 'w') do |f|
#  airports_rough_data.map {|row| f << row}
#end

alphabet.map {|a|
  documents = (base_url + a).url_to_document
  table_elements = documents.xpath("//table/tbody/tr")
  contents = table_elements.map {|r| r.children.map {|e| e.text}}.map {|r| r.map {|f| f.gsub("\n", '')}}
  binding.pry
}

