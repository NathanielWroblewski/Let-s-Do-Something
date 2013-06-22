require 'xmlsimple'

desc "Import Kumutu activities"

CATEGORY_KUMUTU = {   
  1001 => {"Abseiling" => 1},
  1053 => {"Aerobatic Flights" => 2},
  1014 => {"Ballooning" => 6},
  1002 => {"Big Swing" => 10},
  1004 => {"Bungy Jumping" => 17},
  1005 => {"Canyoning" => 20},
  1006 => {"Caving" => 21},
  1051 => {"Coasteering" => 23},
  1052 => {"Cycling (road)" => 24},
  1008 => {"Deep Sea Fishing" => 25},
  1049 => {"Dog Sledding" => 26},
  1055 => {"Fishing" => 29},
  1050 => {"Glacier Hiking" => 32},
  1009 => {"Gliding" => 33},
  1010 => {"Hang Gliding" => 35},
  1011 => {"Helicopter Flights" => 36},
  1012 => {"Heliskiing" => 37},
  1013 => {"Hiking / Trekking" => 38},
  1048 => {"Horseback Riding" => 40},
  1015 => {"Ice Climbing" => 42},
  1016 => {"Jet Boating" => 43},
  1017 => {"Jet Skiing" => 44},
  1018 => {"Kayaking (whitewater)" => 45},
  1019 => {"Kayaking / Canoeing" => 45},
  1020 => {"Kitesurfing" => 46},
  1022 => {"Microlight Flights" => 48},
  1023 => {"Mountain Biking" => 50},
  1024 => {"Mountaineering" => 51},
  1025 => {"Oceanic Expeditions" => 53},
  1026 => {"Off-Road 4x4" => 54},
  1056 => {"Overlanding" => 55},
  1054 => {"Paddleboarding" => 56},
  1027 => {"Paragliding" => 58},
  1028 => {"Parasailing" => 59},
  1029 => {"River Boarding" => 63},
  1030 => {"Rock Climbing" => 64},
  1057 => {"Ropes Course" => 66},
  1031 => {"Safaris" => 54},
  1032 => {"Sailing" => 69},
  1033 => {"Sandboarding" => 70},
  1034 => {"Scuba Diving" => 71},
  1035 => {"Skiing / Snowboarding" => 73},
  1036 => {"Sky Diving" => 74},
  1037 => {"Snorkelling" => 75},
  1039 => {"Snowmobiling" => 77},
  1040 => {"Surfing" => 81},
  1041 => {"Wakeboarding" => 87},
  1046 => {"Walking Safaris" => 88},
  1042 => {"Waterskiing" => 90},
  1047 => {"Whale Watching" => 91},
  1043 => {"Whitewater Rafting" => 92},
  1044 => {"Windsurfing" => 93},
  1045 => {"Zip Line" => 97}
}

task :import_kumutu => :environment do 

  a = Mechanize.new
  a.get("http://api.kumutu.com/0.5/activities/get.xml?apikey=45133376751abc670270301.89648122")
  xml = a.page.body
  status = XmlSimple.xml_in(xml)
  activities = status["Activity"]

  def duration_calc(dstart,dend)
    if dstart && dend
      (dend - dstart) / 3600
    else
      0
    end
  end

  def extern_taken(extern)
    Activity.find_by_extern_id(extern)
  end
  counter = 0

  activities.each do |activity|
    extern_id = "kumutu" + activity["ActivityName"][0]["ID"]
    kumutu_category_id = activity["Category"][1]["CategoryItem"][0]["ID"].to_i
    category_name = CATEGORY_KUMUTU[kumutu_category_id].keys[0]
    category_id = CATEGORY_KUMUTU[kumutu_category_id].values[0]
    min_price = activity["General"][0]["Charge"][0]["MinPrice"].to_f if activity["General"][0]["Charge"][0]["MinPrice"]
    max_price = activity["General"][0]["Charge"][0]["MaxPrice"].to_f if activity["General"][0]["Charge"][0]["MaxPrice"]
    title = activity["ActivityName"][0]["content"]
    description = activity["MultimediaDescriptions"][0]["MultimediaDescription"][0]["TextItems"][0]["TextItem"][0]["Description"][0]["content"]
    image_url = activity["MultimediaDescriptions"][0]["MultimediaDescription"][1]["ImageItems"][0]["ImageItem"][0]["ImageFormat"][-1]["URL"][0] if activity["MultimediaDescriptions"][0]["MultimediaDescription"][1]["ImageItems"][0] != {}
    city = activity["Address"][0]["CityName"][0]
    region = activity["Address"][0]["StateProv"][0]["StateCode"][-2..-1]
    country = Country.find_by_code(activity["Address"][0]["CountryName"][0]["Code"][0..1])
    url = activity["URLs"][0]["URL"][0]["content"]
    lat = activity["Position"][0]["Latitude"].to_f
    long = activity["Position"][0]["Longitude"].to_f
    dates = activity["DateRanges"][0]["DateRange"]

    print "Kumutu Now parsing >>>>>> "
    FPrinter.blue("#{category_name}")
    print " - which contains - "
    FPrinter.blue("#{dates.length} dates")

    def find_region_id(code)
      return nil if code.nil?
      @region = Region.find_by_code(code.downcase)
      if @region
        @region.id
      else
        nil
      end
    end

    if country
      dates.each do |date|
        starts_at = Time.parse(date["StartDate"]) if date["StartDate"]
        ends_at = Time.parse(date["EndDate"]) if date["EndDate"]
        counter += 1
        if extern_taken(extern_id)
          print "Kumutu Update #{category_name} - #{title}"
          extern_taken(extern_id).update_attributes({
            :category_id => category_id,
            :extern_id => extern_id,
            :title => title,
            :description => description,
            :starts_at => starts_at,
            :ends_at => ends_at,
            :lat => lat,
            :long => long,
            :duration => duration_calc(starts_at,ends_at),
            :city => city,
            :region_id => find_region_id(region),
            :url => url,
            :image_url => image_url}
            ) ?  FPrinter.green(" >> success") : FPrinter.red(" >> failed")
        else
          print "Kumutu Create #{category_name} - #{title}"
          act = Activity.create(
            :category_id => category_id,
            :extern_id => extern_id,
            :title => title,
            :description => description,
            :starts_at => starts_at,
            :ends_at => ends_at,
            :lat => lat,
            :long => long,
            :duration => duration_calc(starts_at,ends_at),
            :city => city,
            :region_id => find_region_id(region),
            :url => url,
            :image_url => image_url
            ) 
          country.activities << act
          @region.activities << act if @region
          act.id ? FPrinter.green(" >> success") : FPrinter.red(" >> failed")
        end
      end
    end
  end
  print "Kumutu Printed >>>>>> "
  FPrinter.blue("#{counter} items")
end
