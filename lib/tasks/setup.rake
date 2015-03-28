namespace :db do
  task setup_with_zero: :environment do
    #Spree::User.where.not(email: 'admin@mparty.com').delete_all
   # Spree::Product.destroy_all
    Event.destroy_all
   # Venue.destroy_all
    # Picture.destroy_all
    Picture.where(imageable_type: 'Event').destroy_all
    Spree::Order.destroy_all
   # Spree::User.update_all(bill_address_id: nil)
   # Spree::User.update_all(ship_address_id: nil)
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE average_caches;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE comments;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE events;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE inv_requests;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE invites;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE overall_averages;")
   # ActiveRecord::Base.connection.execute("TRUNCATE TABLE pictures;")

    #ActiveRecord::Base.connection.execute("TRUNCATE TABLE rates;")
   # ActiveRecord::Base.connection.execute("TRUNCATE TABLE reviews;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE rating_caches;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE rsvps;")

   # ActiveRecord::Base.connection.execute("TRUNCATE TABLE spree_addresses;")
    #ActiveRecord::Base.connection.execute("TRUNCATE TABLE spree_adjustments;")
    #ActiveRecord::Base.connection.execute("TRUNCATE TABLE spree_assets;")
    #ActiveRecord::Base.connection.execute("TRUNCATE TABLE spree_inventory_units;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE spree_line_items;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE spree_log_entries;")
    #ActiveRecord::Base.connection.execute("TRUNCATE TABLE spree_option_types;")
    #ActiveRecord::Base.connection.execute("TRUNCATE TABLE spree_option_types_prototypes;")
    #ActiveRecord::Base.connection.execute("TRUNCATE TABLE spree_option_values;")
    #ActiveRecord::Base.connection.execute("TRUNCATE TABLE spree_option_values_variants;")


    #ActiveRecord::Base.connection.execute("TRUNCATE TABLE spree_line_items;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE spree_orders;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE spree_orders_promotions;")
    #ActiveRecord::Base.connection.execute("TRUNCATE TABLE spree_credit_cards;")
   # ActiveRecord::Base.connection.execute(delete_except_first('spree_credit_cards',1))
   # ActiveRecord::Base.connection.execute(delete_except_first('spree_line_items',2))
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE spree_payments;")
    #ActiveRecord::Base.connection.execute("TRUNCATE TABLE spree_prices;")
    # ActiveRecord::Base.connection.execute("TRUNCATE TABLE spree_product_option_types;")
    # ActiveRecord::Base.connection.execute("TRUNCATE TABLE spree_product_properties;")
    # ActiveRecord::Base.connection.execute("TRUNCATE TABLE spree_products;")
    # ActiveRecord::Base.connection.execute("TRUNCATE TABLE spree_products_promotion_rules;")
    # ActiveRecord::Base.connection.execute("TRUNCATE TABLE spree_products_taxons;")
    # ActiveRecord::Base.connection.execute("TRUNCATE TABLE spree_promotion_action_line_items;")
    # ActiveRecord::Base.connection.execute("TRUNCATE TABLE spree_promotion_actions;")
    # ActiveRecord::Base.connection.execute("TRUNCATE TABLE spree_promotion_rules;")
    # ActiveRecord::Base.connection.execute("TRUNCATE TABLE spree_promotion_rules_users;")
    # ActiveRecord::Base.connection.execute("TRUNCATE TABLE spree_promotions;")

    #
    # ActiveRecord::Base.connection.execute("TRUNCATE TABLE spree_shipments;")
    # ActiveRecord::Base.connection.execute("TRUNCATE TABLE spree_shipping_rates;")
    # ActiveRecord::Base.connection.execute("TRUNCATE TABLE spree_state_changes;")
    # ActiveRecord::Base.connection.execute("TRUNCATE TABLE spree_stock_items;")
    # ActiveRecord::Base.connection.execute("TRUNCATE TABLE spree_stock_movements;")
    # ActiveRecord::Base.connection.execute("TRUNCATE TABLE spree_tax_categories;")
    # ActiveRecord::Base.connection.execute("TRUNCATE TABLE spree_tax_rates;")
    # ActiveRecord::Base.connection.execute("TRUNCATE TABLE spree_taxonomies;")
    # ActiveRecord::Base.connection.execute("TRUNCATE TABLE spree_taxons;")
    # ActiveRecord::Base.connection.execute("TRUNCATE TABLE spree_tokenized_permissions;")
    # ActiveRecord::Base.connection.execute("TRUNCATE TABLE spree_user_authentications;")
    # ActiveRecord::Base.connection.execute("TRUNCATE TABLE spree_variants;")

    ActiveRecord::Base.connection.execute("TRUNCATE TABLE spree_wished_products;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE spree_wishlists;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE wishlist_orders;")
  #  ActiveRecord::Base.connection.execute("TRUNCATE TABLE venues;")
   # ActiveRecord::Base.connection.execute("TRUNCATE TABLE trigrams;")
   # ActiveRecord::Base.connection.execute("TRUNCATE TABLE venue_calendars;")
   #  ActiveRecord::Base.connection.execute("TRUNCATE TABLE venue_contacts;")
   #  ActiveRecord::Base.connection.execute("TRUNCATE TABLE venue_categories;")
   #  ActiveRecord::Base.connection.execute("TRUNCATE TABLE venue_categories_venues;")
   #  ActiveRecord::Base.connection.execute("TRUNCATE TABLE venue_seating_types;")
   #  ActiveRecord::Base.connection.execute("TRUNCATE TABLE video_urls;")
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