class CreateVenueCategoriesVenues < ActiveRecord::Migration
  def change
    create_table :venue_categories_venues ,:id => false do |t|
      t.integer :venue_id
      t.integer :venue_category_id

    end
  end
end
