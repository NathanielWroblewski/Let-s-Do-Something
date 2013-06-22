require 'csv'

desc "Saving data from TripAdvisorSF to database"

task :save_tripadvisor => :environment do

  mega_array = []

  CSV.foreach('trip_advisor.csv') do |row|
    mega_array << row
  end

  mega_array.each_with_index do |attraction, index|
    attraction[5].gsub!('+',' ')
    activity = Activity.create(:category_id => 130, :extern_id => "tripadvisor#{index}", :title => attraction[0], :description => attraction[6], :phone => attraction[5], :street => attraction[1], :city => attraction[2], :zip => attraction[4], :region_id => 6, :url => 'http://www.tripadvisor.com/Attractions-g60713-Activities-San_Francisco_California.html' ) 
    print attraction[0]
    activity.id ? FPrinter.green(" >> success") : FPrinter.red(" >> failed")
  end
end
