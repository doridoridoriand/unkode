require 'mechanize'
require 'csv'
require 'pry'

alphabet = ('A'..'Z').to_a
base_url = 'https://en.wikipedia.org/wiki/List_of_airports_by_IATA_code:'

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

binding.pry

