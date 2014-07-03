class Event < ActiveRecord::Base

  # Fields ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  field :name
  field :address
  field :starts_at,type: DateTime
  field :ends_at,type: DateTime
  field :end_time,type: DateTime
  field :attendees_count ,type: Integer,default: 0 # counter cache column for attendees count(no of rsvps)

  # Associations ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  belongs_to :user
  belongs_to :owner, foreign_key: "user_id", class_name: "Spree::User" # event created user
  has_many :rsvps ,dependent: :destroy#, before_add: :enforce_rsvp_limit
  has_many :invites,dependent: :destroy

end
