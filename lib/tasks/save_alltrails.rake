require 'csv'

desc "Saving data from AllTrails to database"

task :save_alltrails_to_db => :environment do

  # read data in from csv

  mega_array = []

  CSV.foreach('alltrails.csv') do |row|
    mega_array << row
  end

  # save each into the database

  def existing_trail(trail)
    Activity.find_by_title_and_lat_and_long(trail[0], trail[3].to_f, trail[4].to_f)
  end

  print "Alltrails-Save Now parsing >>>>>> "
  FPrinter.blue("trails")
  print " - which contains - "
  FPrinter.blue("#{mega_array.length}")

  us = Country.find_by_code("US")
  

  mega_array.each do |trail|
    if existing_trail(trail)
      print "Alltrails-Save Update trail - #{trail[0]}"
      existing_trail(trail).update_attributes({
        :title       => trail[0],
        :image_url   => trail[1],
        :url         => trail[2],
        :lat         => trail[3].to_f,
        :long        => trail[4].to_f}
        ) ?  FPrinter.green(" >> success") : FPrinter.red(" >> failed")
    else
      print "Alltrails-Save Create trail - #{trail[0]}"
      act = Activity.create(
        :category_id => 38,
        :title       => trail[0],
        :image_url   => trail[1],
        :url         => trail[2],
        :lat         => trail[3].to_f,
        :long        => trail[4].to_f) 
      us.activities << act
      act.id ? FPrinter.green(" >> success") : FPrinter.red(" >> failed")
    end
  end
end
