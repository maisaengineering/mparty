Spree::User.class_eval do
  has_many :events
  has_many :rsvps
  has_many :invites , foreign_key: "invited_user_id", class_name: "Invite"
  has_many :comments

  after_create :send_email

  #TODO uncomment below after admin has been created
  validates :first_name, :last_name, :phone, presence: true, allow_blank: true

  validates :phone, uniqueness: true, allow_blank: true

  def attending?(event)
  	rsvp = self.rsvps.where(:event_id => event.id).first
    if !rsvp.nil? && rsvp.joined == true
    	true
    else
    	false
    end	
  end

  # adding fb_token column to spree user authentication table
  def apply_omniauth(omniauth)
    if ["facebook", 'google_oauth2'].include? omniauth['provider']
      self.email = omniauth['info']['email'] if email.blank?
    end
    user_authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'], :fb_token => omniauth['credentials']['token'])
  end

  def fb_authentication
    self.user_authentications.where(:provider => "facebook").first
  end 

  def get_friend_emails
    facebook_auth = fb_authentication
    friends = []
    if facebook_auth.present?
      graph = Koala::Facebook::API.new(facebook_auth.fb_token)
      friends = graph.get_connections("me", "friends").collect{|us| us['name']}
    else
      friends = self.invites.group("recipient_email").collect{|u| u.recipient_email}
    end 
    friends
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