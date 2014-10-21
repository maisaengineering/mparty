class InvitesController < ApplicationController
  #before_filter :validate_invite, :only => [:update_invitaion]
  skip_before_filter :auth_user
  layout 'spree_application'

  def update_invitaion
    @invitaion = Invite.where(token: params[:token]).first
    @invitaion.update_attributes(joined: params[:status])
    @event = @invitaion.event
    session[:event_id] = @event.id
    session[:invitaion_id] = @invitaion.id
    if signed_in?
      if @invitaion.recipient_email == current_spree_user.email
        #redirect_to show_invitation_path(@event.id)
        #TODO change has_wishlist in invitation table if user adds wishlist later
        if @invitaion.has_wishlist == true
          @wishlist = @event.wishlist
          flash[:notice] = "Your friend likes following gifts."
          render "/events/_wishlist_cart"
        else
          redirect_to event_path(id: @event.id)
        end
      else
        flash[:notice] = "Access denied.You are not invited to this event"
        redirect_to event_path(id: @event.id)
      end  
    else  
      if @invitaion.has_wishlist == true 
        @wishlist = @event.wishlist
        flash[:notice] = "Your friend likes following gifts."
        render "/events/_wishlist_cart"
      else  
        redirect_to event_path(id: @event.id)
      end 
    end 
  end

=begin  private

  def validate_invite
    email = params[:invite_email]
    existing_user = Spree::User.find_by_email(email)
    if existing_user.present?
      true
    else
      redirect_to spree.signup_path(:invite_email => email)
    end  
  end
=end
end
