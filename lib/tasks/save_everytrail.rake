require 'csv'

desc "Saving data from EveryTrail to database"

task :save_everytrail_to_db => :environment do

  # read data in from csv

  mega_array = []

  CSV.foreach('everytrail.csv') do |row|
    mega_array << row
  end

  def existing_trail(trail)
    Activity.find_by_title_and_city(trail[0], trail[1])
  end

  print "Everytrail-Save Now parsing >>>>>> "
  FPrinter.blue("trails")
  print " - which contains - "
  FPrinter.blue("#{mega_array.length}")

  # save each into the database
  us = Country.find_by_code("US")
  cali = Region.find_by_code("ca")

  mega_array.each do |trail|
    if existing_trail(trail)
      print "Everytrail-Save Update trail - #{trail[0]}"
      existing_trail(trail).update_attributes({
        :title       => trail[0],
        :city        => trail[1],
        :description => trail[3],
        :url         => trail[4]}
        ) ?  FPrinter.green(" >> success") : FPrinter.red(" >> failed")
    else
      print "Everytrail-Save Create trail - #{trail[0]}"
      act = Activity.create(
        :category_id => 38,
        :title       => trail[0],
        :city        => trail[1],
        :region_id   => cali.id,
        :description => trail[3],
        :url         => trail[4])
      us.activities << act      
      act.id ? FPrinter.green(" >> success") : FPrinter.red(" >> failed")
    end
  end
end
