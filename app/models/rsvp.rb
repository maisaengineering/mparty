class Rsvp < ActiveRecord::Base
  # Associations ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  belongs_to :user, foreign_key: "user_id", class_name: "Spree::User"
  belongs_to :event, counter_cache: :attendees_count

  # Callbacks :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  after_create :invite_joined
  after_destroy :invite_rejected
  # Scopes ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

  # update status of invite to true(joined) if invited to this event
  def invite_joined
    invite = Invite.where(event_id: event_id,user_id: user_id).first
    invite.update_attribute(:joined,1) if invite
  end
  # update status of invite to false(un-joined) if invited to this event
  def invite_rejected
    invite = Invite.where(event_id: event_id,user_id: user_id).first
    invite.update_attribute(:joined, 2) if invite
  end

end
