class CreateFacilitiesVenues < ActiveRecord::Migration
  def change
    create_table :facilities_venues ,id: false do |t|
      t.integer :venue_id,null: false,index: true
      t.integer :venue_facility_id,null: false,index: true
    end
  end
end
