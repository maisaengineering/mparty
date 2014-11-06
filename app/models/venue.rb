class Venue < ActiveRecord::Base
  has_many :events
  has_many :pictures, as: :imageable
  has_many :reviews, as: :reviewable

  belongs_to :owner, foreign_key: "user_id", class_name: "Spree::User" # event created user


  VENUE_TYPES = ['Conference Centres','Convention Centres','Retreats','Banquet','Hotels']

  # GEO
  geocoded_by :full_address, if: ->(rec){ rec.address1.present? and rec.zip.present? }
  after_validation :geocode          # auto-fetch coordinates

  def full_address
    "#{address1} #{address2} #{city} #{state} #{country} #{zip}"
  end


end
