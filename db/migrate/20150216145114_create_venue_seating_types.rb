class CreateVenueSeatingTypes < ActiveRecord::Migration
  def change
    create_table :venue_seating_types do |t|
      t.string :name
      t.references :venue, index: true

      t.timestamps
    end
  end
end
