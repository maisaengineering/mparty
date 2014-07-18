Spree::User.class_eval do
  has_many :events
  has_many :rsvps
  has_many :invites

  after_create :send_email

  def attending?(event)
  	rsvp = self.rsvps.where(:event_id => event.id).first
    if !rsvp.nil? && rsvp.joined == true
    	true
    else
    	false
    end	
  end

  def send_email
    Notifier.welcome_email(email).deliver
  end

  def wishlist
    default_wishlist = self.wishlists.where(is_default: true).first
    default_wishlist ||= self.wishlists.first
    default_wishlist ||= self.wishlists.create(:name => Spree.t(:default_wishlist_name), :is_default => true)
    default_wishlist.update_attribute(:is_default, true) unless default_wishlist.is_default?
    default_wishlist
  end

end