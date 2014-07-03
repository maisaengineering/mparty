class Rsvp < ActiveRecord::Base
  # Associations ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  belongs_to :user
  belongs_to :event,counter_cache: :attendees_count

  # Callbacks :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  after_create :invite_joined
  after_destroy :invite_unjoined
  # Scopes ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

  # update status of invite to true(joined) if invited to this event
  def invite_joined
    invite = Invite.where(event_id: event_id,user_id: user_id).first
    invite.update_attribute(:joined,true) if invite
  end
  # update status of invite to false(un-joined) if invited to this event
  def invite_unjoined
    invite = Invite.where(event_id: event_id,user_id: user_id).first
    invite.update_attribute(:joined,false) if invite
  end

end
