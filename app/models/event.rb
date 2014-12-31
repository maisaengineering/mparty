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

  before_create :create_venue_calander

  accepts_nested_attributes_for :pictures


  alias_attribute :shipping_address, :ship_address
  accepts_nested_attributes_for :ship_address

  validate :validate_duplicate_event_name

  validates :name,:template_id, :starts_at,:description,:city,:state,:country,:zip, presence: true
  validates_presence_of :location, :unless => :venue_id?

  #scopes
  scope :public, -> { where(is_private:  false) }
  scope :private, -> { where(is_private:  true) }
  scope :past, -> { where("starts_at < ?", Date.today)}
  scope :upcoming, -> { where("starts_at >= ?", Date.today).order(starts_at: :asc)}
  scope :invited, ->(email) { where(id: Invite.where(recipient_email: email).map(&:event_id))}

  scope :trending,-> {  public.upcoming.order(starts_at: :asc) }

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

  def is_owner?(user=nil)
    return false if user.nil?
    user_id.eql?(user.id)
  end

  # cover photo
  def event_photo
    pictures.first
  end

  def full_address
    "#{location} #{city} #{state} #{country} #{zip}"
  end

  def map_address
    "#{location},#{city},#{state},#{country},#{zip}"
  end

  private
  
  def validate_duplicate_event_name
      @events=Event.where("starts_at>=? AND starts_at>=? AND is_private=?",Date.today,Time.now,false)
      @events.each do |event|
       if(self.name == event.name)
        errors.add(:Event_Name,"Already exists ")
        break
         end
      end
  end

  def create_venue_calander
   if self.venue_id.present? 
     venue_calendar = VenueCalendar.new 
     venue_calendar.start_date = self.starts_at
     venue_calendar.venue_id = self.venue_id
     end_date = self.ends_at.present? ? self.ends_at : self.starts_at  
     venue_calendar.end_date = end_date
     if !venue_calendar.valid?
      errors.add(:event, "Invalid Start and End dates.")
     else
      venue_calendar.save 
     end 
   end  
  end  
end
