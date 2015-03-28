class CreateFeaturesVenues < ActiveRecord::Migration
  def change
    create_table :features_venues ,id: false do |t|
      t.integer :venue_id,null: false,index: true
      t.integer :venue_feature_id,null: false,index: true
    end
  end
end
