require 'csv'

desc "Now scraping from EveryTrail.com"

task :scrape_everytrail => :environment do
  
  # initialize mechanize

  agent = Mechanize.new

  # initialize arrays for the data to be scraped into

  titles       = []
  locations    = []
  cities       = []
  difficulties = []
  links        = []

  # urls to be scraped

  urls = ['http://www.everytrail.com/best/hiking-california',
          'http://www.everytrail.com/best/hiking-yosemite-national-park',
          'http://www.everytrail.com/best/hiking-lassen-volcanic-national-park',
          'http://www.everytrail.com/best/hiking-mount-diablo-state-park',
          'http://www.everytrail.com/best/hiking-sequoia-national-park',
          'http://www.everytrail.com/best/hiking-point-reyes-national-seashore',
          'http://www.everytrail.com/best/hiking-bay-area-california',
          'http://www.everytrail.com/best/hiking-marin-california',
          'http://www.everytrail.com/best/hiking-lake-tahoe-california',
          'http://www.everytrail.com/best/hiking-oakland-california',
          'http://www.everytrail.com/best/hiking-san-jose-california']

  # scrape each url

  urls.each do |url|
    page = agent.get(url)

  # collect title info

    page.search('.title')[1..-3].each do |title| 
      titles << title.text.strip
    end

  # collect location info

    page.search('.light-text').each do |location|
      locale = location.text.strip.gsub(/(\t|\n)/,'').gsub(/([(].*[)])/,'')
      locations << locale
      cities    << locale.split(',')[0]
    end

  # collect hike difficulty info
    page.search('.meta').each do |difficulty|
      difficulties << difficulty.text.strip.gsub(/(\t|\n)/,'')
    end

  # collect links to each listing

    page.search('.title a')[1..-1].each do |link|
      links << "http://www.everytrail.com" + link.attributes['href'].to_s
    end
  end

  # zip all arrays together for export to csv

  mega_array = titles.zip(cities, locations, difficulties, links)

  # export to csv

  CSV.open('everytrail.csv', 'wb') do |csv|
    mega_array.each do |array|
      csv << array
    end
  end
end
