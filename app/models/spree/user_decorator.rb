Spree::User.class_eval do
  has_many :events
  has_many :rsvps
  has_many :invites

	def upcoming_events
		self.attended_events.upcoming
	end

	def previous_events
		self.attended_events.past
	end

	def attending?(event)
		event.attendees.include?(self)
	end

	def attend!(event)
		self.invites.create!(attended_event_id: event.id)
	end

	def cancel!(event)
		self.invites.find_by(attended_event_id: event.id).destroy
	end
	
end