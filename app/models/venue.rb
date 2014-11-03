class Venue < ActiveRecord::Base
  has_many :events
  has_many :pictures, as: :imageable
  has_many :reviews, as: :reviewable
end
