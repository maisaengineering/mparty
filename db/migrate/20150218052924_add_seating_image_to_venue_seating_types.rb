class AddSeatingImageToVenueSeatingTypes < ActiveRecord::Migration
  def change
    add_column :venue_seating_types, :seating_image, :string
    add_column :venue_seating_types, :capacity_min, :integer
    add_column :venue_seating_types, :capacity_max, :integer    
  end
end
