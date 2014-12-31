
namespace :db do
  task setup_with_zero: :environment do
    Event.destroy_all
    Venue.destroy_all
    Picture.destroy_all
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE events;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE comments;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE invites;")

    ActiveRecord::Base.connection.execute("TRUNCATE TABLE venues;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE trigrams;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE venue_calendars;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE venue_contacts;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE reviews;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE rates;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE rate_caches;")

    ActiveRecord::Base.connection.execute("TRUNCATE TABLE spree_wished_products;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE spree_wishlists;")

  end



end