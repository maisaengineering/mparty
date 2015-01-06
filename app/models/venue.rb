class Venue < ActiveRecord::Base

  #--------- Attributes & Variables
  VENUE_TYPES = ['Conference Centres','Convention Centres','Retreats','Banquet','Hotels']

  #--------- Relations
  has_many :venue_calendars
  has_many :events, through: :venue_calendars
  has_many :pictures, as: :imageable, dependent: :destroy
  has_many :reviews, as: :reviewable, dependent: :destroy
  has_many :venue_contacts, inverse_of: :venue,dependent: :destroy
  belongs_to :created_by, foreign_key: "user_id", class_name: "Spree::User" # event created user

  ratyrate_rateable 
  has_many :rates, as: :rateable, dependent: :destroy
  has_one :rating_cache, as: :cacheable, dependent: :destroy
  has_and_belongs_to_many :venue_categories 
  #Scopes ------------------
  scope :top_five,-> {where(promote: true).order(priority: :desc).limit(5)}
  scope :top_rated,-> {joins(:rating_cache).order("rating_caches.avg desc").limit(5)}

  #--------- Validations goes here
  validates :name,:address1, :address2, :state, :city, :country,:zip,presence: true
  #validates_associated :venue_calendars, :venue_contacts

  #--------  Callbacks goes here
  # GEO
  geocoded_by :full_address, if: ->(rec){ rec.address1.present? and rec.zip.present? }
  after_validation :geocode          # auto-fetch coordinates

  accepts_nested_attributes_for :venue_contacts, allow_destroy: true,reject_if: proc { |attributes| attributes['full_name'].blank? }

  #Fuzzy search
  fuzzily_searchable :name


  # Venue advance search
  def self.advance_search(query)
      where("name LIKE ? OR city LIKE ? OR state LIKE ? OR zip LIKE ? ", "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%")
  end


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

  def original_score_average
    self.rating_cache.avg
  end  

  def can_review?(user)
    invitation = Invite.where(joined: 1, user_id: user.id)
    venue_id = nil
    past_invitation = false
    if invitation.present?
       venue_id = invitation.first.event.venue_id
       past_invitation = true if invitation.first.event.starts_at < DateTime.now
    end    

    owner_venue_id = nil
    is_owner_of_event = Invite.where(invited_user_id: user.id)
    past_event = false
    if is_owner_of_event.present?
       owner_venue_id = is_owner_of_event.first.event.venue_id
       past_event = true if is_owner_of_event.first.event.starts_at < DateTime.now
    end   

    if (owner_venue_id == self.id && past_event) || (invitation.present? && venue_id == self.id && past_invitation)
      if user.reviews.where(reviewable_id: self.id, reviewable_type: self.class.name).size.zero?
         return true
      else
         return false
      end   
    else
      return false
    end  
  end  
  
end
