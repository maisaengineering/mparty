class VenueCalendar < ActiveRecord::Base
	belongs_to :venue

	validates_presence_of :start_date, :end_date
	validate :end_date_is_after_start_date
    
  	private

	def end_date_is_after_start_date
	  return if end_date.blank? || start_date.blank?
	  if end_date < start_date
	    errors.add(:end_date, "cannot be before the start date") 
	  end
		# puts "!~~~~~~~~~~~~#{venue.venue_calendars.where('(start_date BETWEEN ? AND ?) OR (end_date BETWEEN ? AND ?)', self.start_date,self.end_date,self.start_date,self.end_date).inspect}"
		if venue.venue_calendars.where('(start_date BETWEEN ? AND ?) OR (end_date BETWEEN ? AND ?)', self.start_date,self.end_date,self.start_date,self.end_date).exists?
			errors.add(:venue, "is already exist with this Schedule.") 
		end 
	end
end