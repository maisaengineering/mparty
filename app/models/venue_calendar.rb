class VenueCalendar < ActiveRecord::Base
	belongs_to :venue
	belongs_to :event
	belongs_to :created_by, foreign_key: "user_id", class_name: "Spree::User"

	validates_presence_of :start_date, :end_date, :event_id
	validates_uniqueness_of :start_date, scope: :venue_id
	validate :end_date_is_after_start_date
	#validate :valid_slots
    
  private

	def end_date_is_after_start_date
	  return if end_date.blank? || start_date.blank?
	  if self.start_date.today? && self.start_date.hour < Time.now.hour
       errors.add(:start_date, "will be grater than current time") 
	  elsif end_date < start_date
	    errors.add(:end_date, "can't be before the start date") 
	  else
	    valid_slots  
	  end
	end

	def valid_slots
		if venue.present? && venue.venue_calendars.where('(start_date BETWEEN ? AND ?) OR (end_date BETWEEN ? AND ?) ', self.start_date,self.end_date,self.start_date,self.end_date).exists?
			errors.add(:venue, "is already exist with this Schedule.") 
		end 
	end	
end