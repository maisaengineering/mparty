
namespace :db do
  task setup_with_zero: :environment do
    Event.destroy_all
    Venue.destroy_all
    Picture.destroy_all
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE events;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE comments;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE invites;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE overall_averages;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE pictures;")

    ActiveRecord::Base.connection.execute("TRUNCATE TABLE rates;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE reviews;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE rating_caches;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE rsvps;")

    ActiveRecord::Base.connection.execute("TRUNCATE TABLE spree_addresses;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE spree_line_items;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE spree_orders;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE spree_orders_promotions;")
   # ActiveRecord::Base.connection.execute(delete_except_first('spree_credit_cards',1))
   # ActiveRecord::Base.connection.execute(delete_except_first('spree_line_items',2))
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE spree_wished_products;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE spree_wishlists;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE wishlist_orders;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE venues;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE trigrams;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE venue_calendars;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE venue_contacts;")
  end


  def delete_except_first(table,limit)
    "DELETE FROM #{table}
      WHERE id NOT IN (
        SELECT id
        FROM (
          SELECT id
          FROM spree_line_items
          ORDER BY id ASC
          LIMIT #{limit}
        ) foo
      );"
  end



end