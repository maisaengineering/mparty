class InvitesController < ApplicationController
	  def create
    @event = Event.find(params[:invite][:event_id])
    current_spree_user.attend!(@event)
    redirect_to @event
  end

  def destroy
    @event = Invite.find(params[:id]).attended_event
    current_spree_user.cancel!(@event)
    redirect_to @event
  end
end
