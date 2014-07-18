class InvitesController < ApplicationController
  #before_filter :validate_invite, :only => [:update_invitaion]

  def update_invitaion
    inv = Invite.where(token: params[:token]).first
    inv.update_attributes(joined: params[:status])
    redirect_to spree.root_url
  end

=begin  def create
    @event = Event.find(params[:invite][:event_id])
    current_spree_user.attend!(@event)
    redirect_to @event
  end

  def destroy
    @event = Invite.find(params[:id]).attended_event
    current_spree_user.cancel!(@event)
    redirect_to @event
  end
=end
  private

  def validate_invite
    email = params[:invite_email]
    existing_user = Spree::User.find_by_email(email)
    if existing_user.present?
      true
    else
      redirect_to spree.signup_path(:invite_email => email)
    end  
  end

end
