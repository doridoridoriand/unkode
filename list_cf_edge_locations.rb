require 'mechanize'
require 'json'

# Scrape CloudFront edge locations from Wikipedia
url = 'https://en.wikipedia.org/wiki/Amazon_CloudFront'

def scrape_edge_locations
  agent                  = Mechanize.new
  agent.log              = Logger.new STDOUT
  agent.user_agent_alias = 'Mac Safari'
  
  page = agent.get('https://en.wikipedia.org/wiki/Amazon_CloudFront')
  doc = page.parser
  
  edge_locations = []
  
  # Find tables that might contain edge location data
  tables = doc.xpath("//table[contains(@class, 'wikitable')]")
  
  tables.each do |table|
    rows = table.xpath(".//tr")
    
    rows.each_with_index do |row, index|
      next if index == 0 # Skip header row
      
      cells = row.xpath(".//td")
      next if cells.empty?
      
      # Extract data from table cells
      location_data = cells.map { |cell| cell.text.strip }
      
      # Try to extract structured data
      if location_data.length >= 2
        edge_location = {
          city: location_data[0],
          country: location_data[1],
          airport_code: location_data[2]&.strip || '',
          region: location_data[3]&.strip || ''
        }
        
        edge_locations << edge_location if edge_location[:city] && !edge_location[:city].empty?
      end
    end
  end
  
  edge_locations
end

# Alternative: Parse from AWS documentation or use known edge locations
def get_known_edge_locations
  # Based on AWS documentation and public information about CloudFront edge locations
  [
    { city: 'Amsterdam', country: 'Netherlands', airport_code: 'AMS', region: 'Europe' },
    { city: 'Atlanta', country: 'United States', airport_code: 'ATL', region: 'North America' },
    { city: 'Ashburn', country: 'United States', airport_code: 'IAD', region: 'North America' },
    { city: 'Auckland', country: 'New Zealand', airport_code: 'AKL', region: 'Asia Pacific' },
    { city: 'Bangkok', country: 'Thailand', airport_code: 'BKK', region: 'Asia Pacific' },
    { city: 'Bangalore', country: 'India', airport_code: 'BLR', region: 'Asia Pacific' },
    { city: 'Beijing', country: 'China', airport_code: 'PEK', region: 'Asia Pacific' },
    { city: 'Berlin', country: 'Germany', airport_code: 'BER', region: 'Europe' },
    { city: 'Bogotá', country: 'Colombia', airport_code: 'BOG', region: 'South America' },
    { city: 'Boston', country: 'United States', airport_code: 'BOS', region: 'North America' },
    { city: 'Brussels', country: 'Belgium', airport_code: 'BRU', region: 'Europe' },
    { city: 'Bucharest', country: 'Romania', airport_code: 'OTP', region: 'Europe' },
    { city: 'Budapest', country: 'Hungary', airport_code: 'BUD', region: 'Europe' },
    { city: 'Buenos Aires', country: 'Argentina', airport_code: 'EZE', region: 'South America' },
    { city: 'Cairo', country: 'Egypt', airport_code: 'CAI', region: 'Middle East' },
    { city: 'Cape Town', country: 'South Africa', airport_code: 'CPT', region: 'Africa' },
    { city: 'Chennai', country: 'India', airport_code: 'MAA', region: 'Asia Pacific' },
    { city: 'Chicago', country: 'United States', airport_code: 'ORD', region: 'North America' },
    { city: 'Copenhagen', country: 'Denmark', airport_code: 'CPH', region: 'Europe' },
    { city: 'Dallas/Fort Worth', country: 'United States', airport_code: 'DFW', region: 'North America' },
    { city: 'Delhi', country: 'India', airport_code: 'DEL', region: 'Asia Pacific' },
    { city: 'Denver', country: 'United States', airport_code: 'DEN', region: 'North America' },
    { city: 'Dubai', country: 'United Arab Emirates', airport_code: 'DXB', region: 'Middle East' },
    { city: 'Dublin', country: 'Ireland', airport_code: 'DUB', region: 'Europe' },
    { city: 'Frankfurt', country: 'Germany', airport_code: 'FRA', region: 'Europe' },
    { city: 'Geneva', country: 'Switzerland', airport_code: 'GVA', region: 'Europe' },
    { city: 'Hamburg', country: 'Germany', airport_code: 'HAM', region: 'Europe' },
    { city: 'Helsinki', country: 'Finland', airport_code: 'HEL', region: 'Europe' },
    { city: 'Hong Kong', country: 'Hong Kong SAR', airport_code: 'HKG', region: 'Asia Pacific' },
    { city: 'Houston', country: 'United States', airport_code: 'IAH', region: 'North America' },
    { city: 'Hyderabad', country: 'India', airport_code: 'HYD', region: 'Asia Pacific' },
    { city: 'Istanbul', country: 'Turkey', airport_code: 'IST', region: 'Europe' },
    { city: 'Jakarta', country: 'Indonesia', airport_code: 'CGK', region: 'Asia Pacific' },
    { city: 'Johannesburg', country: 'South Africa', airport_code: 'JNB', region: 'Africa' },
    { city: 'Kuala Lumpur', country: 'Malaysia', airport_code: 'KUL', region: 'Asia Pacific' },
    { city: 'Lagos', country: 'Nigeria', airport_code: 'LOS', region: 'Africa' },
    { city: 'Lisbon', country: 'Portugal', airport_code: 'LIS', region: 'Europe' },
    { city: 'London', country: 'United Kingdom', airport_code: 'LHR', region: 'Europe' },
    { city: 'Los Angeles', country: 'United States', airport_code: 'LAX', region: 'North America' },
    { city: 'Madrid', country: 'Spain', airport_code: 'MAD', region: 'Europe' },
    { city: 'Manchester', country: 'United Kingdom', airport_code: 'MAN', region: 'Europe' },
    { city: 'Manila', country: 'Philippines', airport_code: 'MNL', region: 'Asia Pacific' },
    { city: 'Marseille', country: 'France', airport_code: 'MRS', region: 'Europe' },
    { city: 'Melbourne', country: 'Australia', airport_code: 'MEL', region: 'Asia Pacific' },
    { city: 'Mexico City', country: 'Mexico', airport_code: 'MEX', region: 'North America' },
    { city: 'Miami', country: 'United States', airport_code: 'MIA', region: 'North America' },
    { city: 'Milan', country: 'Italy', airport_code: 'MXP', region: 'Europe' },
    { city: 'Minneapolis', country: 'United States', airport_code: 'MSP', region: 'North America' },
    { city: 'Montreal', country: 'Canada', airport_code: 'YUL', region: 'North America' },
    { city: 'Mumbai', country: 'India', airport_code: 'BOM', region: 'Asia Pacific' },
    { city: 'Munich', country: 'Germany', airport_code: 'MUC', region: 'Europe' },
    { city: 'Nairobi', country: 'Kenya', airport_code: 'NBO', region: 'Africa' },
    { city: 'New York', country: 'United States', airport_code: 'JFK', region: 'North America' },
    { city: 'Newark', country: 'United States', airport_code: 'EWR', region: 'North America' },
    { city: 'Osaka', country: 'Japan', airport_code: 'KIX', region: 'Asia Pacific' },
    { city: 'Oslo', country: 'Norway', airport_code: 'OSL', region: 'Europe' },
    { city: 'Palermo', country: 'Italy', airport_code: 'PMO', region: 'Europe' },
    { city: 'Paris', country: 'France', airport_code: 'CDG', region: 'Europe' },
    { city: 'Perth', country: 'Australia', airport_code: 'PER', region: 'Asia Pacific' },
    { city: 'Philadelphia', country: 'United States', airport_code: 'PHL', region: 'North America' },
    { city: 'Phoenix', country: 'United States', airport_code: 'PHX', region: 'North America' },
    { city: 'Prague', country: 'Czech Republic', airport_code: 'PRG', region: 'Europe' },
    { city: 'Pune', country: 'India', airport_code: 'PNQ', region: 'Asia Pacific' },
    { city: 'Rio de Janeiro', country: 'Brazil', airport_code: 'GIG', region: 'South America' },
    { city: 'Rome', country: 'Italy', airport_code: 'FCO', region: 'Europe' },
    { city: 'San Francisco', country: 'United States', airport_code: 'SFO', region: 'North America' },
    { city: 'San Jose', country: 'United States', airport_code: 'SJC', region: 'North America' },
    { city: 'Santiago', country: 'Chile', airport_code: 'SCL', region: 'South America' },
    { city: 'São Paulo', country: 'Brazil', airport_code: 'GRU', region: 'South America' },
    { city: 'Seattle', country: 'United States', airport_code: 'SEA', region: 'North America' },
    { city: 'Seoul', country: 'South Korea', airport_code: 'ICN', region: 'Asia Pacific' },
    { city: 'Singapore', country: 'Singapore', airport_code: 'SIN', region: 'Asia Pacific' },
    { city: 'Sofia', country: 'Bulgaria', airport_code: 'SOF', region: 'Europe' },
    { city: 'Stockholm', country: 'Sweden', airport_code: 'ARN', region: 'Europe' },
    { city: 'Sydney', country: 'Australia', airport_code: 'SYD', region: 'Asia Pacific' },
    { city: 'Taipei', country: 'Taiwan', airport_code: 'TPE', region: 'Asia Pacific' },
    { city: 'Tel Aviv', country: 'Israel', airport_code: 'TLV', region: 'Middle East' },
    { city: 'Tokyo', country: 'Japan', airport_code: 'NRT', region: 'Asia Pacific' },
    { city: 'Toronto', country: 'Canada', airport_code: 'YYZ', region: 'North America' },
    { city: 'Vancouver', country: 'Canada', airport_code: 'YVR', region: 'North America' },
    { city: 'Vienna', country: 'Austria', airport_code: 'VIE', region: 'Europe' },
    { city: 'Warsaw', country: 'Poland', airport_code: 'WAW', region: 'Europe' },
    { city: 'Zurich', country: 'Switzerland', airport_code: 'ZRH', region: 'Europe' }
  ]
end

# Main execution
begin
  puts "Attempting to scrape CloudFront edge locations from Wikipedia..."
  scraped_locations = scrape_edge_locations
  
  if scraped_locations.empty?
    puts "No data scraped from Wikipedia, using known edge locations..."
    edge_locations = get_known_edge_locations
  else
    puts "Successfully scraped #{scraped_locations.length} edge locations"
    edge_locations = scraped_locations
  end
rescue => e
  puts "Error scraping data: #{e.message}"
  puts "Using known edge locations instead..."
  edge_locations = get_known_edge_locations
end

# Write to JSON file
File.open('cf_edge_locations.json', 'w') do |fs|
  fs << edge_locations.to_json
end

puts "CloudFront edge locations saved to cf_edge_locations.json"
puts "Total locations: #{edge_locations.length}"
