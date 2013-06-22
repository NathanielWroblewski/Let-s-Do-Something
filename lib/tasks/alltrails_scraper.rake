require 'json'
require 'csv'

desc "Now scraping from AllTrails.com"

task :scrape_alltrails => :environment do 
  
  # initialize mechanize

  agent = Mechanize.new

  # initialize arrays for the data to be scraped into

  names      = []
  photos     = []
  urls       = []
  latitutdes = []
  longitudes = []
  locations  = []
  item_types = []
  ratings    = []

  # scrape pages 1..21 of http://alltrails.com/search?q=san+francisco

  (1..21).each do |num|
    puts "Scraping page #{ num } of 21"

    page = agent.get('http://alltrails.com/search?page=' + num.to_s + '  &q=san+francisco')
    
    pjson = JSON.parse page.content

  # push content into arrays
  
    pjson["map_pins"].each do |pin|
      names      << pin["name"]
      photos     << pin["photo"]
      latitutdes << pin["latitude"]
      longitudes << pin["longitude"]
      locations  << pin["location"]
      item_types << pin["item_type"]
      ratings    << pin["rating"]
      urls       << "http://alltrails.com" + pin["url"].to_s
    end
  end
 
  # zip arrays together for csv export

  mega_array = names.zip(photos, urls, latitutdes, longitudes, locations, item_types, ratings)

  #export to csv for ease of import into google fusion table/google maps api

  CSV.open('alltrails.csv', 'wb') do |csv|
    mega_array.each do |array|
      csv << array
    end
  end
end
