namespace :db do
  task create_venue_features: :environment do
    VenueFeature.destroy_all
    ['Table/Chairs' ,'Lcd Projector','Built in screens'].each do |e|
      VenueFeature.create(name: e)
    end
  end

  task create_venue_facilities: :environment do
    VenueFacility.destroy_all
    ['Air Conditioned' ,'Catering Indoor','Wi-fi/Internet','Elevator'].each do |e|
      VenueFacility.create(name: e)
    end
  end
end