class CreateVenueCalendars < ActiveRecord::Migration
  def change
    create_table :venue_calendars do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.references :venue
      t.timestamps
    end
  end
end
