#!/usr/bin/env ruby
# Fetches and lists vim colorschemes from vim.org
# Dependencies: gem install mechanize
# Usage: ruby list_vim_colorscheme.rb

require 'mechanize'

agent                  = Mechanize.new
agent.user_agent_alias = 'Mac Safari'

page = agent.get('https://www.vim.org/scripts/script_search_results.php?&script_type=color%20scheme&order_by=rating&show_me=1000')
html = page.content
doc = Nokogiri::HTML.parse(html)

# Get links from both rowodd and roweven classes
rowodd_links = doc.xpath("//td[@class='rowodd']/a")
roweven_links = doc.xpath("//td[@class='roweven']/a")
all_links = (rowodd_links + roweven_links).uniq { |link| link.attributes['href'].value }

# Extract colorscheme information
colorschemes = all_links.map do |link|
  {
    name: link.text.strip,
    url: "https://www.vim.org/scripts/#{link.attributes['href'].value}"
  }
end

# Output the results
puts "Found #{colorschemes.size} vim colorschemes:\n\n"
colorschemes.each_with_index do |scheme, index|
  puts "#{index + 1}. #{scheme[:name]}"
  puts "   #{scheme[:url]}\n\n"
end
