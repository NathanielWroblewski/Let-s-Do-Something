require 'json'

  desc "Import SeatGeek activities"

CATEGORY_SEATGEEK = {
  "animal_sports" => 112,
  "auto_racing" => 4,
  "baseball" => 8,
  "basketball" => 9,
  "boxing" => 113,
  "broadway_tickets_national" => 114,
  "cirque_du_soleil" => 115,
  "classical" => 116,
  "classical_opera" => 116,
  "classical_orchestral_instrumental" => 116,
  "classical_vocal" => 116,
  "comedy" => 114,
  "concert" => 117,
  "dance_performance_tour" => 115,
  "european_soccer" => 79,
  "extreme_sports" => 118,
  "f1" => 119,
  "family" => 120,
  "football" => 31,
  "golf" => 34,
  "hockey" => 39,
  "horse_racing" => 121,
  "indycar" => 122,
  "international_soccer" => 79,
  "literary" => 123,
  "lpga" => 34,
  "minor_league_baseball" => 8,
  "minor_league_hockey" => 39,
  "mlb" => 9,
  "mls" => 79,
  "mma" => 124,
  "monster_truck" => 125,
  "motocross" => 126,
  "music_festival" => 127,
  "nascar" => 128,
  "nascar_nationwide" => 128,
  "nascar_sprintcup" => 128,
  "nba" => 9,
  "ncaa_baseball" => 8,
  "ncaa_basketball" => 9,
  "ncaa_football" => 31,
  "ncaa_hockey" => 39,
  "ncaa_womens_basketball" => 9,
  "nfl" => 31,
  "nhl" => 39,
  "olympic_sports" => 129,
  "pga" => 34,
  "rodeo" => 130,
  "soccer" => 79,
  "sports" => 129,
  "tennis" => 83,
  "theater" => 114,
  "wnba" => 9,
  "wrestling" => 131
}.freeze

task :import_seatgeek => :environment do 

  a = Mechanize.new

  CATEGORY_SEATGEEK.each do |seatgeek_cat, cat_id|
    a.get("http://api.seatgeek.com/2/events?type=#{seatgeek_cat}&per_page=2000&page=1")
    content = a.page.body
    json = JSON.parse(content)

    def extern_taken(extern)
      Activity.find_by_extern_id(extern)
    end

    print "SeatGeek Now parsing >>>>>> "
    FPrinter.blue("#{seatgeek_cat}")
    print " - which contains - "
    FPrinter.blue("#{json["events"].length}")
      
    json["events"].each do |event|
        category_id = CATEGORY_SEATGEEK[event["type"]]
        extern_id = "seatgeek" + event["id"].to_s
        title = event["title"]
        starts_at = Time.parse(event["datetime_utc"]) if event["datetime_utc"]
        url = event["url"]
        city = event["venue"]["city"]
        country = Country.find_by_code(event["venue"]["country"])
        zip = event["venue"]["postal_code"]
        lat = event["venue"]["location"]["lat"]
        long = event["venue"]["location"]["lon"]
        min_price = event["stats"]["lowest_price"]
        max_price = event["stats"]["highest_price"]
        
        if extern_taken(extern_id)
          print "SeatGeek Update #{event["type"]} - #{title}"
          extern_taken(extern_id).update_attributes({
          :category_id => category_id,
          :title => title,
          :lat => lat,
          :long => long,
          :starts_at => starts_at,
          :city => city,
          :zip => zip,
          :min_price => min_price,
          :max_price => max_price,
          :url => url}
          ) ?  FPrinter.green(" >> success") : FPrinter.red(" >> failed")
        else
          if country
            print "SeatGeek Create #{event["type"]} - #{title}"
            act = Activity.create(
            :category_id => category_id,
            :extern_id => extern_id,
            :title => title,
            :lat => lat,
            :long => long,
            :starts_at => starts_at,
            :city => city,
            :zip => zip,
            :min_price => min_price,
            :max_price => max_price,
            :url => url
            ) 
            country.activities << act
            act.id ? FPrinter.green(" >> success") : FPrinter.red(" >> failed")
          else
            puts "Skipped, wrong country name: #{event["venue"]["country"]}"
          end
      end
    end
  end
end
