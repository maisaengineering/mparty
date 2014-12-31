class AddUserAndEventToVenueCalendar < ActiveRecord::Migration
  def change
  	add_column :venue_calendars, :event_id, :integer
  	add_column :venue_calendars, :user_id, :integer
  end
end
