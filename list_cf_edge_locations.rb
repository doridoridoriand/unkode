require 'mechanize'
require 'csv'
require 'pry'

agent                  = Mechanize.new
agent.log              = Logger.new STDOUT
logger                 = Logger.new STDOUT
agent.user_agent_alias = 'Mac Safari'

page              = agent.get('http://www.jpsgl.com/code-search')
html              = page.content
doc               = Nokogiri::HTML.parse(html)
airport_codes_raw = doc.xpath("//div[@class='tabbox']")
rows_html_element = airport_codes_raw.first.children[1]

airports_rough_data = rows_html_element.children.map {|row|
  if row.name == 'tr'
    row.children.map {|r|
      logger.info("#{r.children.text} parsed.")
      r.children.text if r.name != 'text'
    }
  end
}.compact.map {|r| r.compact}

CSV.open('airports.csv', 'w') do |f|
  airports_rough_data.map {|row| f << row}
end

