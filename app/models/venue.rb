class Venue < ActiveRecord::Base

  #--------- Attributes & Variables
  VENUE_TYPES = ['Conference Centres','Convention Centres','Retreats','Banquet','Hotels']

  #--------- Relations
  has_many :events
  has_many :pictures, as: :imageable
  has_many :reviews, as: :reviewable
  has_many :venue_contacts, inverse_of: :venue,dependent: :destroy
  has_many :venue_calendars, dependent: :destroy 
  belongs_to :created_by, foreign_key: "user_id", class_name: "Spree::User" # event created user

  ratyrate_rateable "venue_rating"
  #Scopes ------------------
  scope :top_five,-> {where(promote: true).order(priority: :desc).limit(5)}

  #--------- Validations goes here
  validates :name,:address1,:zip,presence: true

  #--------  Callbacks goes here
  # GEO
  geocoded_by :full_address, if: ->(rec){ rec.address1.present? and rec.zip.present? }
  after_validation :geocode          # auto-fetch coordinates

  accepts_nested_attributes_for :venue_contacts, allow_destroy: true,reject_if: proc { |attributes| attributes['full_name'].blank? }

  #Fuzzy search
  fuzzily_searchable :name

  #---------  Class Methods goes here

  #---------- Instance Methods
  def full_address
    "#{address1} #{address2} #{city} #{state} #{country} #{zip}"
  end

  # cover photo
  def cover_photo
    pictures.first
  end

  def self.search(query=nil)
    all
  end
  
end
