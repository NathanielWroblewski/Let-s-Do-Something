task :all => [:import_seatgeek, :import_sfgate, :import_yelp, :save_alltrails_to_db, :save_everytrail_to_db, :import_kumutu, :save_transit_and_trails_trailhead_data_to_db, :save_tripadvisor]

task :google => [:import_address, :import_latlong]
