class InvitesController < ApplicationController
  #before_filter :validate_invite, :only => [:update_invitaion]

  def update_invitaion
    @invitaion = Invite.where(token: params[:token]).first
    @invitaion.update_attributes(joined: params[:status])
    @event = @invitaion.event
    if @invitaion.has_wishlist == true 
      @wishlist = @event.wishlist
      render "/events/wishlist_cart"
    else  
      redirect_to spree.root_url
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
