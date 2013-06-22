require 'csv'

desc "Saving data from TransitAndTrails to database"

task :save_transit_and_trails_trailhead_data_to_db => :environment do

  mega_array = []

  CSV.foreach('transit_and_trails_trailheads') do |row|
    mega_array << row
  end

  def existing_trail(trail)
    Activity.find_by_title_and_lat_and_long(trail[0], trail[2].to_f, trail[3].to_f)
  end

  print "Trans and Trails Now parsing >>>>>> "
  FPrinter.blue("trails")
  print " - which contains - "
  FPrinter.blue("#{mega_array.length}")
  
  us = Country.find_by_code("US")

  mega_array.each do |trail|
    if existing_trail(trail)
      print "Trans and Trails Update trail - #{trail[0]}"
      existing_trail(trail).update_attributes({
        :category_id => 38,
        :title       => trail[0],
        :description => "#{ trail[4] } #{ trail[1] }",
        :lat         => trail[2].to_f,
        :long        => trail[3].to_f,
        :url         => "http://www.transitandtrails.org/"}
        ) ?  FPrinter.green(" >> success") : FPrinter.red(" >> failed")
    else
      print "Trans and Trails Create trail - #{trail[0]}"
      act = Activity.create(
        :category_id => 38,
        :title       => trail[0],
        :description => "#{ trail[4] } #{ trail[1] }",
        :lat         => trail[2].to_f,
        :long        => trail[3].to_f,
        :url         => "http://www.transitandtrails.org/")
      us.activities << act
      act.id ? FPrinter.green(" >> success") : FPrinter.red(" >> failed")
    end
  end
end
