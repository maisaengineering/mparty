Spree::User.class_eval do
  has_many :events
  has_many :rsvps
  has_many :invites	

  def attending?(event)
  	rsvp = self.rsvps.where(:event_id => event.id).first
    if !rsvp.nil? && rsvp.joined == true
    	true
    else
    	false
    end	
  end	
end