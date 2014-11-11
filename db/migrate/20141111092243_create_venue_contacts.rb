class CreateVenueContacts < ActiveRecord::Migration
  def change
    create_table :venue_contacts do |t|
      t.references :venue, index: true
      t.string :full_name
      t.string :mobile_number
      t.string :land_number
      t.timestamps
    end
  end
end
