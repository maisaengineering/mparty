class VenueCalendar < ActiveRecord::Base
	belongs_to :venue

	validates_presence_of :start_date, :end_date
	validates_uniqueness_of :start_date, scope: :venue_id
	validate :end_date_is_after_start_date
	validate :valid_slots
    
  private

	def end_date_is_after_start_date
	  return if end_date.blank? || start_date.blank?
	  if end_date < start_date
	    errors.add(:end_date, "can't be before the start date") 
	  end
	end

	def valid_slots
		if venue.present? && venue.venue_calendars.where('(DATE(?) BETWEEN start_date AND end_date)', self.start_date).exists?
			errors.add(:venue, "is already exist with this Schedule.") 
		end 
	end	
end