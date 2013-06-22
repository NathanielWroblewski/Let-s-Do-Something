require 'json'

desc "google map name import"

task :import_latlong => :environment do 

  a = Mechanize.new

  list_to_check = Activity.where(:lat => nil).where("city IS NOT NULL")
  list_to_check.length > 1000 ? num_to_run = 1000 : num_to_run = list_to_check.length

  num_to_run.times do |i|
    activity = list_to_check[i]
    @street = activity.street ||= ""
    @city = activity.city ||= ""
    @zip = activity.zip ||= ""
    @region = activity.region.code ||= ""
    address = " #{@street} +" + "#{@city} +" + "#{@zip} +"  + "#{@region}"
    a.get("http://maps.googleapis.com/maps/api/geocode/json?address=#{address}&sensor=false")
    content = a.page.body
    json = JSON.parse(content)

    print "Google LatLong Now collecting >>>>>> "
    FPrinter.blue("#{@street} #{@city} #{@region}")

    if json["status"] == "OVER_QUERY_LIMIT" 
      FPrinter.red(("*" * 30) + "OVER QUERY LIMIT" + ("*" * 30))
    end

    act = json["results"][0]
    if act
      element = act["address_components"][0]
      case element["types"][0]
      when "route"
        @street_name = element["long_name"]
      when "locality"
        @city = element["long_name"]
      when "administrative_area_level_1"
        @region = element["short_name"]
      when "postal_code"
        @zip = element["long_name"].to_i
      end
    end

    def find_region_id(code)
      return nil if code.nil?
      @region = Region.find_by_code(code.downcase)
      if @region
        @region.id
      else
        nil
      end
    end

    lat = act["geometry"]["location"]["lat"]
    long = act["geometry"]["location"]["lng"]
    print "Google LatLong Update #{activity.title}"
    activity.update_attributes({
      :long => long,
      :lat => lat,
      :street => @street_name,
      :city => @city,
      :region_id => find_region_id(@region),
      :zip => @zip}
      ) ?  FPrinter.green(" >> success") : FPrinter.red(" >> failed")
  end
end
