Spree::User.class_eval do
  has_many :events
  has_many :rsvps
  has_many :invites	
end