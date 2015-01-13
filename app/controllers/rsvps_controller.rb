class RsvpsController < ApplicationController
  before_filter :auth_user
  before_filter :find_event

  # POST /events/:event_id/join
  def join
    # create self invitation(i.e invited_by/invited_user_id is blank)
   invite = @event.invites.find_or_create_by(user: spree_current_user ,recipient_email: spree_current_user.email)
   invite.update_attribute(:joined,1)
    respond_to do |format|
      format.html{
        flash[:success] = "Successfully Joined."
        redirect_to event_path(@event)
      }
    end
  end

  # DELETE /events/:event_id/disjoin
  def disjoin
    invite = @event.invites.where('user_id=? OR recipient_email=?', spree_current_user.id, spree_current_user.email).first
    # self invitation
    if invite and invite.invited_user_id.nil?
      invite.destroy
    elsif invite
      invite.update_attribute(:joined ,0) # pending
    end
    respond_to do |format|
      format.html{
        flash[:success] = "You have Left this event"
        redirect_to event_path(@event)
      }
    end

  end

  private
  def find_event
    begin
      @event = Event.find(params[:event_id])
      if @event.is_private?
        flash[:error] = "Access Denied(is not a public event)"
        redirect_to :back and return
      end
    rescue
      render text: 'Event not found' and return
    end
  end

end
