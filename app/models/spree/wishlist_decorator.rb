Spree::Wishlist.class_eval do
	belongs_to :event
	validates :event_id, :uniqueness => true
end