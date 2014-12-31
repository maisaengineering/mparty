class VenueContact < ActiveRecord::Base
  belongs_to :venue, inverse_of: :venue_contacts
  validates_presence_of :venue
  validates :full_name, :mobile_number, presence: true
end
