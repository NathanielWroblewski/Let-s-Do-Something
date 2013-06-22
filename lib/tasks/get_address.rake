require 'json'

desc "google map name import"

task :import_address => :environment do 

  a = Mechanize.new

  list_to_check = Activity.where(:zip => nil)

  1000.times do |i|
    activity = list_to_check[i]
    lat = activity.lat if activity
    long = activity.long if activity
    a.get("http://maps.googleapis.com/maps/api/geocode/json?latlng=#{lat},#{long}&sensor=false")
    content = a.page.body
    json = JSON.parse(content)

    print "Google Address Now collecting >>>>>> "
    FPrinter.blue("#{lat} & #{long}")

    act = json["results"][0]
    if act 
      act["address_components"].each do |element|
        case
        when element["types"][0] == "route"
          @street_name = element["long_name"]
        when element["types"][0] == "locality"
          @city = element["long_name"]
        when element["types"][0] == "administrative_area_level_1"
          @region = element["short_name"]
        when element["types"][0] == "postal_code"
          @zip = element["long_name"].to_i
        else
        end
      end
      def find_region_id(code)
        return nil if code.nil?
        region = Region.find_by_code(code.downcase)
        if region
          region.id
        else
          nil
        end
      end
      print "Google Address Update #{activity.title}"
      activity.update_attributes({
        :street => @street_name,
        :city => @city,
        :region_id => find_region_id(@region),
        :zip => @zip}
      ) ?  FPrinter.green(" >> success") : FPrinter.red(" >> failed")
    end
  end
end
