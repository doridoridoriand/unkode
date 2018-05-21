require 'mechanize'
require 'pry'

agent                  = Mechanize.new
agent.log              = Logger.new STDOUT
agent.user_agent_alias = 'Mac Safari'

page = agent.get('https://www.vim.org/scripts/script_search_results.php?&script_type=color%20scheme&order_by=rating&show_me=1000')
html = page.content
doc = Nokogiri::HTML.parse(html)

item_detail_page = doc.xpath("//td[@class='rowodd']/a").map {|r| r.attributes['href'].value}.uniq
absolute_item_detail_page_links = item_detail_page.map {|l| "https://www.vim.org/scripts/#{l}"}

binding.pry
