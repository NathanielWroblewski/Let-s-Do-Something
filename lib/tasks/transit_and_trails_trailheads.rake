require 'csv'
require 'json'

desc "Now querying TransitAndTrails.com API"

task :query_transit_and_trails_api => :environment do
  
  # initialize mechanize

  agent = Mechanize.new

  # initialize arrays for the data to be scraped into

  trailheads   = []
  descriptions = []
  longitudes   = []
  latitudes    = []
  park_names   = []

  # convert page to JSON

  page = agent.get('https://api.transitandtrails.org/api/v1/trailheads?key=1ff51fe70f236fda01e9d0d8796218dd974893702ded023b9fa7cf8859acfea3')

  page_son = JSON.parse(page.content)

  # get data

  page_son.each_with_index do |trail, index|

    puts "scraping #{ index + 1 } of #{ page_son.length }"

    trailheads << trail['name']
    longitudes << trail['longitude']
    latitudes  << trail['latitude']
    park_names << trail['park_name']

    trail['description'].nil? ? (descriptions << trail['description']) : (descriptions << trail['description'].gsub(/(<.*>)/,'').strip.gsub(/(\n|\r|\t)/,''))
    
  end

  # zip data for export to csv

  mega_array = trailheads.zip(descriptions, latitudes, longitudes, park_names)
  
  # export data to csv for future integration with google fusion tables and google maps api

  CSV.open('transit_and_trails_trailheads', 'wb') do |csv|
    mega_array.each do |trail|
      csv << trail
    end
  end
end
