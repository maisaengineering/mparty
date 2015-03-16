class AddVenueTypeToEvent < ActiveRecord::Migration
  def change
    add_column :events, :venue_type, :string
  end
end
