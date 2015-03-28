class VenueFeature < ActiveRecord::Base
  validates :name ,presence: true ,uniqueness: true

  has_and_belongs_to_many :venues, join_table: 'features_venues'
end
