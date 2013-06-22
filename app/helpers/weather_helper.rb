module WeatherHelper

  def api_call(location, date = Time.now)
    weather_url(location, date)
    query_world_weather_online(@url)
    return @weather
  end

  def weather_url(location,date)
    @url = 'http://api.worldweatheronline.com/free/v1/weather.ashx?key=fj3e7u2z9e4xggxygz5qmzc2'
    append_location_query(location)
    @url << '&format=json'
    @url << "&date=#{date}" if date.future?
  end

  def append_location_query(location)
    @url << "&q=#{location}" if zip?(location)
    @url << "&q=#{location[0]}%2C#{location[1]}" if latlong?(location)
  end

  def zip?(location)
    location =~ /\d{5}/
  end

  def latlong?(location)
    location.is_a?(Array) && location.length == 2 && location[0].is_a?(Fixnum) && location[1].is_a?(Fixnum)
  end

  def future?(date) # but less than 5 days in the future
    date > to_day
  end

  def to_day
    year  = Time.now.year
    month = Time.now.month
    day   = Time.now.day
    month = "0" + month.to_s if month < 10
    day   = "0" + day.to_s if day < 10
    "#{year}-#{month}-#{day}"
  end

  def query_world_weather_online(url)
    agent = Mechanize.new
    page = agent.get(url)

    page_son = JSON.parse(page.body)

    initialize_weather_data
    five_day_forecast = page_son['data']['weather']
    if five_day_forecast
      five_day_forecast.each do |day|
        @dates          << day['date']
        @max_temp_f     << day['tempMaxF']
        @min_temp_f     << day['tempMinF']
        @description    << day['weatherDesc'][0]['value']
        @weather_icon   << day['weatherIconUrl'][0]['value']
        @wind_direction << day['winddirection']
        @wind_speed_mph << day['windspeedMiles']
        @weather_code   << day['weatherCode']
      end
    end
    store_all
  end

  def initialize_weather_data
    @dates          = []
    @max_temp_f     = []
    @min_temp_f     = []
    @description    = []
    @weather_icon   = []
    @wind_direction = []
    @wind_speed_mph = []
    @weather_code   = []
  end

  def store_all
    @weather = [ @dates,
                 @max_temp_f,
                 @min_temp_f,
                 @description,
                 @weather_icon,
                 @wind_direction,
                 @wind_speed_mph,
                 @weather_code ]
  end
end
