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
  has_many :pictures, as: :imageable
  has_many :comments, as: :commentable

  accepts_nested_attributes_for :pictures


  alias_attribute :shipping_address, :ship_address
  accepts_nested_attributes_for :ship_address

  validates :name, :starts_at, presence: true
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

end
