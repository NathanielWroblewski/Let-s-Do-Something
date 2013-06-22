require 'json'

  desc "Import Yelp SF activities"

CATEGORY_YELP = {
  "amateursportsteams" => { 3   => "Amateur"},
  "amusementparks"     => { 61  => "Rec & Wellness" },
  "aquariums"          => { 108 => "Aquariums"},
  "archery"            => { 109 => "Archery" },
  "badminton"          => { 110 => "Badminton" },
  "beaches"            => { 111 => "Beaches" },
  "bikerentals"        => { 24  => "Cycling" },
  "boating"            => { 13  => "Boating" },
  "owling"             => { 103 => "Bowling" },
  "climbing"           => { 107 => "Climbing" },
  "diving"             => { 71  => "Scuba Diving" },
  "fishing"            => { 29  => "Fishing" },
  "swimminglessons"    => { 82  => "Swimming" },
  "yoga"               => { 96  => "Yoga" },
  "goarts"             => { 106 => "Go Karts" },
  "golf"               => { 34  => "Golf" },
  "hanggliding"        => { 35  => "Hang Gliding" },
  "hiking"             => { 38  => "Hiking / Trekking" },
  "horseracing"        => { 121 => "Horse Racing" },
  "horsebackriding"    => { 40  => "Horseback Riding" },
  "hot_air_balloons"   => { 105 => "Hot Air Balloons" },
  "kiteboarding"       => { 46  => "Kite Surfing" },
  "lasertag"           => { 104 => "Lazer tag" },
  "leisurecenters"     => { 61  => "Rec & Wellness" },
  "mountainbiking"     => { 50  => "Mountain Biking" },
  "paddleboarding"     => { 56  => "Paddleboarding" },
  "paintball"          => { 57  => "Paintball" },
  "parks"              => { 61  => "Rec & Wellness" },
  "skateparks"         => { 72  => "Skateboarding" },
  "playgrounds"        => { 61  => "Rec & Wellness" },
  "rafting"            => { 92  => "Whitewater Rafting" },
  "rockclimbing"       => { 64  => "Rock Climbing" },
  "skydiving"          => { 74  => "Sky Diving" },
  "soccer"             => { 79  => "Soccer" },
  "squash"             => { 102 => "Squash" },
  "surfing"            => { 81  => "Surfing"},
  "swimmingpools"      => { 82  => "Swimming" },
  "tennis"             => { 83  => "Tennis"},
  "trampoline"         => { 101 => "Trampoline Parks" },
  "tubing"             => { 99  => "Tubing" },
  "zoos"               => { 100 => "Zoos"}
}

task :import_yelp => :environment do 

  def act(extern)
    Activity.find_by_extern_id(extern)
  end

  consumer_key = ENV["YELP_CONSUMER_KEY"]
  consumer_secret = ENV["YELP_CONSUMER_SECRET"]
  token = ENV["YELP_TOKEN"]
  token_secret = ENV["YELP_TOKEN_SECRET"]

  api_host = 'api.yelp.com'

  consumer = OAuth::Consumer.new(consumer_key, consumer_secret, {:site => "http://#{api_host}"})
  access_token = OAuth::AccessToken.new(consumer, token, token_secret)

    def find_region_id(code)
      return nil if code.nil?
      @region = Region.find_by_code(code.downcase)
      if @region
        @region.id
      else
        nil
      end
    end

  cats = CATEGORY_YELP.map {|yelp_cat, matches| yelp_cat}
  cats.each do |cat|
    
    print "Yelp Now parsing >>>>>> "
    FPrinter.blue("#{cat}")
    
    path = "/v2/search?category_filter=#{cat}&location=san%20francisco"
    response = access_token.get(path).body
    json = JSON.parse(response)
    if json["businesses"]

      print " - which contains - "
      FPrinter.blue("#{json["businesses"].length}")
      json["businesses"].each do |business|
        loc = business["location"]
        country = Country.find_by_code([loc["country_code"]])
        city = loc["city"]
        region = loc["state_code"]
        extern_id = "yelp" + business["id"].to_s
        zip = loc["postal_code"].to_i
        lat = loc["coordinate"]["latitude"]
        long = loc["coordinate"]["longitude"]
        street = loc["address"].join(" ")
        phone = business["phone"]
        title = business["name"]
        url = business["url"]
        image_url = business["image_url"]
        category_id = CATEGORY_YELP[cat].keys[0]
        if act(extern_id)
          print "Yelp Update #{cat} - #{title}"
          act(extern_id).update_attributes({
            :category_id => category_id,
            :city        =>        city,
            :region_id   =>  find_region_id(region),
            :extern_id   =>   extern_id,
            :zip         =>         zip,
            :lat         =>         lat,
            :long        =>        long,
            :street      =>      street,
            :phone       =>       phone,
            :url         =>         url,
            :image_url   =>   image_url,
            :title       =>       title
            }) ?  FPrinter.green(" >> success") : FPrinter.red(" >> failed")
        else
          print "Yelp Create #{cat} - #{title}"
          act = Activity.create(
            :category_id => category_id,
            :city        =>        city,
            :region_id   =>  find_region_id(region),
            :extern_id   =>   extern_id,
            :zip         =>         zip,
            :lat         =>         lat,
            :long        =>        long,
            :street      =>      street,
            :phone       =>       phone,
            :url         =>         url,
            :image_url   =>   image_url,
            :title       =>       title
            )
          act.id ? FPrinter.green(" >> success") : FPrinter.red(" >> failed")
          country.activities << act
          @region.activities << act if @region
        end
      end
    end
  end
end
