class AddStatusAndRequestedIdToVenueCalendars < ActiveRecord::Migration
  def change
    add_column :venue_calendars, :status, :integer,limit: 1,default: 0 # available
    add_column :venue_calendars, :requested_id, :integer
    add_index :venue_calendars, :status
  end
end
