class CreateVenueCategoriesVenues < ActiveRecord::Migration
  def change
    create_table :venue_categories_venues do |t|
      t.integer :venue_id
      t.integer :venue_category_id

      t.timestamps
    end
  end
end
