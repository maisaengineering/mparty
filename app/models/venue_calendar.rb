class VenueCalendar < ActiveRecord::Base
	belongs_to :venue
	belongs_to :event
	belongs_to :updated_by, foreign_key: "user_id", class_name: "Spree::User"
	belongs_to :requested_by, foreign_key: "requested_id", class_name: "Spree::User"

	validates_presence_of :start_date, :end_date #, :event_id
	validates_uniqueness_of :start_date, scope: :venue_id
	validate :end_date_is_after_start_date
	#validate :valid_slots

  # status: 0 available
  #         1 pending
  #         2 confirmed

  scope :available ,-> { where(status: 0) }
  scope :pending ,-> { where(status: 1) }
  scope :confirmed ,-> { where(status: 2)}
  scope :booked ,->  { where.not(status: 0) }  # not available either in pending or confirmed status
  scope :reserved ,->(starts_at,ends_at) {where.not(status: 0).where("(start_date <= ? AND end_date >= ?) OR (start_date <= ? AND end_date >= ?)",
                                                             starts_at,starts_at,ends_at,ends_at)}

  def color
    case status
      when 0; nil
      when 1; '#f0ad4e' # orange -> waiting for confirmation(pending)
      when 2; '#cccccc' #gray-> not available
    end
  end

  def status_str
    case status
      when 0; 'available'
      when 1; 'pending'
      when 2; 'reserved'  # confirmed
    end
  end

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
		if venue.present? && venue.venue_calendars.reserved(self.start_date,self.end_date).exists?
			errors.add(:venue, "is already exist with this Schedule.") 
		end 
	end	
end