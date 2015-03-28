class CreateVenueFeatures < ActiveRecord::Migration
  def change
    create_table :venue_features do |t|
      t.string :name ,limit: 100,null: false
      t.timestamps
    end
  end
end
