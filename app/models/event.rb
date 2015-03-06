class Event < ActiveRecord::Base

  # Associations ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  belongs_to :user, foreign_key: "user_id", class_name: "Spree::User"
  belongs_to :owner, foreign_key: "user_id", class_name: "Spree::User" # event created user
  belongs_to :ship_address, foreign_key: "shipping_address_id", class_name: "Spree::Address", validate: true
  belongs_to :template, foreign_key: "template_id", class_name: "Spree::Admin::Template"
  belongs_to :venue, foreign_key: "venue_id", class_name: "Venue"


  has_many :rsvps ,dependent: :destroy#, before_add: :enforce_rsvp_limit
  has_many :invites,dependent: :destroy
  has_one :wishlist , class_name: "Spree::Wishlist", :validate => true
  has_many :pictures, as: :imageable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :inv_requests, dependent: :destroy

  # After placing an order --------------------------------
  has_many :wishlist_orders,through: :wishlist
  has_many :orders ,through:  :wishlist
  has_many :wished_products,through: :wishlist
  has_many :purchased_products,through: :wishlist

  before_validation :start_date_end_date_validate_slot_available, :if => Proc.new { |event| event.venue_id_changed?}
  # before_create :fill_end_date_and_time
  after_create :create_venue_calender

  accepts_nested_attributes_for :pictures


  after_create :enqueue_event_design

  after_update :enqueue_event_design,if: Proc.new {|r| r.host_name_changed? or r.starts_at_changed?  or r.ends_at_changed? or r.description_changed?}


  alias_attribute :shipping_address, :ship_address
  accepts_nested_attributes_for :ship_address

  mount_uploader :fb_image, EventTemplateUploader

  #validate :validate_duplicate_event_name

  validates :name,:template_id, :starts_at,:ends_at,:city,:state,:country,:zip, presence: true
  validates_presence_of :location, :unless => :venue_id?

  #scopes
  scope :public, -> { where(is_private:  false) }
  scope :private, -> { where(is_private:  true) }
  scope :past, -> {where.not("ends_at >= ?", Time.now()).order("starts_at ASC","events.name ASC")}
  scope :upcoming, -> { where("ends_at >= ?", Time.now()).order("starts_at ASC","events.name ASC")}
  scope :invited, ->(email) { where(id: Invite.where(recipient_email: email).map(&:event_id))}

  scope :trending,-> {  public.upcoming.order(starts_at: :asc) }


  class << self
    def search(query)
      query = "%#{query}%"
      name_match = arel_table[:name].matches(query)
      city_match = arel_table[:city].matches(query)
      where(name_match.or(city_match))
    end
  end

  def future_event?
    self.ends_at >= Time.now()
  end

  def enqueue_event_design
    EventDesignWorker.perform_async(self.id)
  end

  def attendees(status)
    if status.eql?('pending')
      self.invites.where(joined: 0).count
    elsif status.eql?('accepted')
      self.invites.where(joined: 1).count
    elsif status.eql?('maybe')
      self.invites.where(joined: 3).count
    elsif status.eql?('rejected')
      self.invites.where(joined: 2).count
    end
  end

  def inv_requested?(user)
   user and inv_requests.where(user_id: user.id).exists?
  end

  def is_owner?(user=nil)
    return false if user.nil?
    user_id.eql?(user.id)
  end

  def is_public?
    !is_private?
  end

  def user_joined?(user)
    return false unless user
    invites.where('user_id=? OR recipient_email=?', user.id, user.email).where(joined: 1).exists?
  end

  def user_invited?(user)
    return false unless user
    invites.where('user_id=? OR recipient_email=?', user.id, user.email).where.not(invited_user_id: nil).exists?
  end

  def allow_show?(user=nil)
    return true if is_public?
    return false if user.nil?
    return true if is_owner?(user)
    return  user_invited?(user)
  end

  def show_wishlist?(user)
    return false if wishlist.nil?
    return true if is_owner?(user)
    if is_private?
      user_invited?(user)
    else
      user_invited?(user) or user_joined?(user)
    end
  end

  def allow_checkout?(user)
    return false if wishlist.nil? or is_owner?(user)
    if is_private?
      user_invited?(user)
    else
      user_invited?(user) or user_joined?(user)
    end
  end

  # cover photo
  def event_photo
    pictures.first
  end

  def full_address
    "#{location}, #{city}, #{state}, #{country}, #{zip}"
  end

  def map_address
    "#{location},#{city},#{state},#{country},#{zip}"
  end

  private

=begin
  def validate_duplicate_event_name
    if(Event.public.where('name LIKE ?',self.name).upcoming.exists? && self.is_private == false )
      errors.add(:Event_Name,"Already exists ")
    end
  end
=end

  def create_venue_calender
   if self.venue_id.present?
     venue_calendar = VenueCalendar.new(start_date: starts_at,end_date: ends_at,requested_id: user_id,event_id: id,venue_id: venue_id,status: 1)
     if !venue_calendar.valid?
      errors.add(:event, "Invalid Start and End dates/time for selected Venue slot.")
     else
      venue_calendar.save
     end
   end
  end

  def start_date_end_date_validate_slot_available
    if self.starts_at > self.ends_at
      errors.add(:start_date, "is not less than the end date")
    end
    if venue.present? && venue.venue_calendars.reserved(self.starts_at,self.ends_at).exists?
      errors.add(:slot, "is not available for this dates")
    end
  end

  def fill_end_date_and_time
    if self.ends_at.nil?
      self.ends_at = self.starts_at
    end  
  end  
end
