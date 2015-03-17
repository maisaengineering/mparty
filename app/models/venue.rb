class Venue < ActiveRecord::Base

  #--------- Attributes & Variables
  VENUE_TYPES = ['Conference Centres','Convention Centres','Retreats','Banquet','Hotels']

  #--------- Relations
  has_many :venue_calendars,dependent: :destroy
  has_many :venue_seating_types,dependent: :destroy
  has_many :events, through: :venue_calendars
  has_many :pictures, as: :imageable, dependent: :destroy
  has_many :reviews, as: :reviewable, dependent: :destroy
  has_many :venue_contacts, inverse_of: :venue,dependent: :destroy
  belongs_to :created_by, foreign_key: "user_id", class_name: "Spree::User" # event created user
  has_many :video_urls, as: :video_url

  has_many :rates, as: :rateable, dependent: :destroy
  has_one :rating_cache, as: :cacheable, dependent: :destroy
  has_and_belongs_to_many :venue_categories
  #Scopes ------------------
  scope :top_five,-> {where(promote: true).order(priority: :asc).limit(6)}
  scope :top_rated,-> {joins(:rating_cache).order("rating_caches.avg desc").limit(5)}

  #--------- Validations goes here
  validates :name,:address1, :state, :city, :country,presence: true
  validates :zip, numericality: true, presence: true
  validates :room_dimensions,:capacity, :allow_blank => true, numericality: { greater_than_or_equal_to: 1 }
  validates :priority,numericality: { greater_than_or_equal_to: 0 }
  validate :min_max_price
  validate :special_notes_not_to_allow_ifames
  #validates_associated :venue_calendars, :venue_contacts

  #--------  Callbacks goes here
  # GEO
  geocoded_by :full_address, if: ->(rec){ rec.address1.present? and rec.zip.present? }
  after_validation :geocode          # auto-fetch coordinates

  accepts_nested_attributes_for :venue_contacts, allow_destroy: true,reject_if: proc { |attributes| attributes['full_name'].blank? }
  accepts_nested_attributes_for :video_urls, allow_destroy: true,reject_if: proc { |attributes| attributes['url'].blank? }

  #Fuzzy search
  fuzzily_searchable :name,:city,:state


  #---------  Class Methods goes here
  # Venue advance search
  def self.advance_search(query)
    query = "%#{query}%"
    name_match = arel_table[:name].matches(query)
    city_match = arel_table[:city].matches(query)
    state_match = arel_table[:state].matches(query)
    zip_match = arel_table[:zip].matches(query)
    where(name_match.or(city_match).or(state_match).or(zip_match))
  end

  # TO Avoid iLike
  def self.basic_search(city,state)
    city_match = arel_table[:city].matches("%#{city}%")
    state_match = arel_table[:state].matches("%#{state}%")
    where(city_match.or(state_match))
  end


  #---------- Instance Methods

  # MINIMUM PRICE - MAX PRICE
  def min_max_price
    if price_min.blank?
      errors.add(:max_price, "Minimum Price can't be blank ")
    elsif (price_min.present? and price_max.present?) and price_max < price_min
      errors.add(:max_price, "can't be less than minimum price")
    end
  end

  def special_notes_not_to_allow_ifames
    if self.special_notes.include?("<iframe>")
      errors.add(:special_notes, "Should not consisting of iframes")
    end
  end

  def full_address
    if address2 == ""
      "#{name}, #{address1}, #{city}, #{state}, #{country}, #{zip}"
    else
      "#{name}, #{address1}, #{address2}, #{city}, #{state}, #{country}, #{zip}"
    end
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
    has_events_with_venue = Event.past.where(:venue_id => self.id, :user_id => user.id)
    past_events = Event.past.where(:venue_id => self.id).ids
    has_invitation_with_venue = Invite.where(joined: 1, user_id: user.id, event_id: past_events)
    if (has_events_with_venue.present? || has_invitation_with_venue.present?)
      has_reviews = user.reviews.where(reviewable_id: self.id, reviewable_type: self.class.name).count.zero?
      return has_reviews ? true : false
    else
      return false
    end
  end

  def average_rating
    reviews.sum(:rating) / reviews.size
  end

end