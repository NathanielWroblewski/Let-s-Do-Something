require 'xmlsimple'

desc "Import SFGate SF activities"

CATEGORY_SFGATE = { "Sports & Outdoors" => 
  { 75  => { 3 => "Amateur"},
    50  => { 4 => "Auto Racing"},
    1056  => { 5 => "Aviation"},
    51  => { 8 => "Baseball"},
    52  => { 9 => "Basketball"},
    1099  => { 11 => "Birding"},
    53  => { 13 => "Boating"},
    54  => { 18 => "Camping"},
    55  => { 24 => "Cycling"},
    1101 => { 27 => "Equestrian"},
    1097  => { 29 => "Fishing"},
    56  => { 31 => "Football"},
    1042  => { 34 => "Golf"},
    57  => { 38 => "Hiking / Trekking"},
    58  => { 39 => "Hockey"},
    1098  => { 41 => "Hunting"},
    1102  => { 47 => "Lacrosse"},
    74  => { 52 => "Nature"},
    1109  => { 61 => "Rec & Wellness"},
    1093  => { 62 => "Recreation"},
    1095  => { 65 => "Rodeo"},
    59  => { 67 => "Running"},
    1100  => { 72 => "Skateboarding"},
    60  => { 79 => "Soccer"},
    1094  => { 80 => "Softball"},
    1043  => { 81 => "Surfing"},
    73  => { 82 => "Swimming"},
    77  => { 83 => "Tennis"},
    79  => { 85 => "Track & Field"},
    76  => { 86 => "Volleyball"},
    1096  => { 94 => "Winter Sports"},
    78  => { 95 => "Wrestling"},
    1055  => { 96 => "Yoga"} 
  }
}

task :import_sfgate => :environment do 

  CATEGORY_SFGATE["Sports & Outdoors"].each do |num, cat|
    a = Mechanize.new
    a.get("http://events.sfgate.com/search?cat=#{num}&new=n&rss=1&sort=0&srad=250.0&srss=100&st=event&swhat=&swhen=&swhere=San+Francisco%2CCA")
    xml = a.page.body
    status = XmlSimple.xml_in(xml)
    activities = status["channel"][0]["item"]

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

    def title_crop(title)
      title.gsub(/ at .*/, '')
    end

    print "SFGate Now parsing >>>>>> "
    FPrinter.blue("#{cat.values[0]}")
    print " - which contains - "
    FPrinter.blue("#{activities.length}")

    cali = Region.find_by_code('ca')
    
    activities.each do |activity|
        extern_id = "sfgate" + activity["id"][0].to_s
        title = activity["title"][0].gsub("Event: ","")
        description = activity["description"][0] if activity["description"][0] != {} 
        phone = activity["phone"][0] if activity["phone"][0] != {} 
        creator = activity["creator"][0] if activity["creator"][0] != {} 
        lat = activity["lat"][0].to_f if activity["lat"][0] != {} 
        long = activity["long"][0].to_f if activity["long"][0] != {} 
        starts_at = Time.parse(activity["dtstart"][0]) if activity["dtstart"][0] != {} 
        ends_at = Time.parse(activity["dtend"][0]) if activity["dtend"][0] != {} 
        venue_name = activity["x-calconnect-venue"][0]['adr'][0]["x-calconnect-venue-name"][0]
        street = activity["x-calconnect-venue"][0]['adr'][0]["x-calconnect-street"][0]
        city = activity["x-calconnect-venue"][0]['adr'][0]["x-calconnect-city"][0]
        zip = activity["x-calconnect-venue"][0]['adr'][0]["x-calconnect-postalcode"][0].to_i if activity["x-calconnect-venue"][0]['adr'][0]["x-calconnect-postalcode"][0]  != {}
        country = Country.find_by_name(activity["x-calconnect-venue"][0]['adr'][0]["x-calconnect-country"][0])
        recurrence = activity["recurrences"][0] if activity["recurrences"][0] != {} 
        url = (activity["x-calconnect-venue"][0]["url"][0] if activity["x-calconnect-venue"][0]["url"][0] != {}) if activity["x-calconnect-venue"][0]["url"]
        image_url = (activity["image"][0]["url"][0] if activity["image"][0]["url"]) if activity["image"]
        title = title_crop(title)
        
        if extern_taken(extern_id)
          print "SFGate Update #{cat.values[0]} - #{title}"
          extern_taken(extern_id).update_attributes({
          :category_id => cat.keys[0],
          :extern_id => extern_id,
          :title => title,
          :description => description,
          :phone => phone,
          :creator => creator,
          :lat => lat,
          :long => long,
          :starts_at => starts_at,
          :ends_at => ends_at,
          :duration => duration_calc(starts_at,ends_at),
          :venue_name => venue_name,
          :street => street,
          :city => city,
          :region_id => cali.id,
          :zip => zip,
          :recurrence => recurrence,
          :url => url,
          :image_url => image_url}
          ) ?  FPrinter.green(" >> success") : FPrinter.red(" >> failed")
        else
          print "SFGate Create #{cat.values[0]} - #{title}"
          act = Activity.create(
          :category_id => cat.keys[0],
          :extern_id => extern_id,
          :title => title,
          :description => description,
          :phone => phone,
          :creator => creator,
          :lat => lat,
          :long => long,
          :starts_at => starts_at,
          :ends_at => ends_at,
          :duration => duration_calc(starts_at,ends_at),
          :venue_name => venue_name,
          :street => street,
          :city => city,
          :region_id => cali.id,
          :zip => zip,
          :recurrence => recurrence,
          :url => url,
          :image_url => image_url
          ) 
          country.activities << act
          cali.activities << act
          act.id ? FPrinter.green(" >> success") : FPrinter.red(" >> failed")
      end
    end
  end
end
