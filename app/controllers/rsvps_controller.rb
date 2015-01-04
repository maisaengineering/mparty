class RsvpsController < ApplicationController
  before_filter :auth_user
  before_filter :find_event

  # POST /events/:event_id/join
  def join
    # create self invitation(i.e invited_by/invited_user_id is blank)
    @event.invites.create!(user: spree_current_user ,recipient_email: spree_current_user.email,joined: 1,mail_sent: false)
    respond_to do |format|
      format.html{
        flash[:success] = "Successfully Joined."
        redirect_to event_path(@event)
      }
    end
  end

  # DELETE /events/:event_id/disjoin
  def disjoin
    invite = @event.invites.where(user: spree_current_user,invited_user_id: nil).first
    invite.destroy if invite
    respond_to do |format|
      format.html{
        flash[:success] = "You are dis-joined from event"
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
