class CreateVenueCategories < ActiveRecord::Migration
  def change
    create_table :venue_categories do |t|
      t.string :venue_type

      t.timestamps
    end
  end
end
