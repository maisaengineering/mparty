class VenueCategory < ActiveRecord::Base
	has_and_belongs_to_many :venues
	validates :venue_type, :presence => true, :uniqueness => true

	before_validation :titleize_strings

	def titleize_strings
	  self.venue_type = self.venue_type.split.collect(&:titleize).join(' ')
	end
end
