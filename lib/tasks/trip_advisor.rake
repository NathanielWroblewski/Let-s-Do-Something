require 'csv'

desc "Now scraping from TripAdvisor.com"

task :scrape_tripadvisor => :environment do

  i = Time.now

  agent = Mechanize.new

  url = 'http://www.tripadvisor.com/Attractions-g28926-Activities-California.html'

  page = agent.get(url)

  @titles       = []
  @streets      = []
  @cities       = []
  @regions      = []
  @zips         = []
  @phones       = []
  @descriptions = []
  @urls         = []

  @event_counter = 0
  @page_counter  = 0

  def scrape(array, node)
    if node.nil?
      array << ""
    else
      array << node.text.strip.gsub(/\n/, " ")
    end
  end

  def scrape_all_data(page)
    scrape(@titles, page.search('#HEADING')[0].children)
    scrape(@streets, page.search('.street-address'))
    scrape(@cities, page.search('.locality').children.children[0])
    scrape(@regions, page.search('.locality').children.children[1])
    scrape(@zips, page.search('.locality').children.children[2])
    scrape(@phones, page.search('.odcHotel')[0].children[1])
    scrape(@descriptions, page.search('.onShow'))
    @urls << page.uri.to_s
  end

  def tally_event
    @event_counter += 1
    puts "Scraping Event #{@event_counter}"
  end

  def scrape_event_page(page, agent)
    page.search('.property_title').each do |attraction|
      tally_event
      event_page = Mechanize::Page::Link.new(attraction, agent, page).click
      FPrinter.cyan(event_page.uri.to_s)
      scrape_all_data(event_page)
    end
  end

  def paginate(page)
    @paginator = page.search('.sprite-pageNext')[0]
  end

  def tally_page
    puts "Scraping Page #{@page_counter}"
    @page_counter += 1
  end

  def scrape_list_page(area, agent, page)
    tally_page
    @list_page = Mechanize::Page::Link.new(area, agent, page).click
    FPrinter.magenta(@list_page.uri.to_s)
    scrape_event_page(@list_page, agent)
    paginate(@list_page)
  end

  def scrape_main_page(page, agent)
    page.search('.geo_name a').each do |area|
      scrape_list_page(area, agent, page)
      until @paginator.nil?
        scrape_list_page(@paginator, agent, @list_page)
      end
    end
  end

  scrape_main_page(page, agent)

  mega_array = @titles.zip(@streets, @cities, @regions, @zips, @phones, @descriptions, @urls)

  CSV.open('trip_advisor.csv','wb') do |csv|
    mega_array.each do |array|
      csv << array
    end
  end

  puts "Finished in #{Time.now - i}"
end
