class Event < ActiveRecord::Base

  # Associations ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  belongs_to :user, foreign_key: "user_id", class_name: "Spree::User"
  belongs_to :owner, foreign_key: "user_id", class_name: "Spree::User" # event created user
  has_many :rsvps ,dependent: :destroy#, before_add: :enforce_rsvp_limit
  has_many :invites,dependent: :destroy
  has_one :wishlist , class_name: "Spree::Wishlist"

  validates :name, :location, :starts_at, presence: true

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
end
